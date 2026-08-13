# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

class GraphAuditTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  AUDIT = File.join(ROOT, "skills", "co-founder-setup", "references", "graph-audit")

  def with_vault
    Dir.mktmpdir("graph-audit-") do |dir|
      FileUtils.mkdir_p(File.join(dir, "wiki", "initiatives"))
      FileUtils.mkdir_p(File.join(dir, "wiki", "business", "content"))
      FileUtils.mkdir_p(File.join(dir, "hub"))
      yield dir
    end
  end

  def write(root, path, content)
    target = File.join(root, path)
    FileUtils.mkdir_p(File.dirname(target))
    File.write(target, content)
  end

  # Pin file mtimes to the fixture date so graph-audit's "updated predates file modification" check
  # reflects the fixture, not the day the test runs.
  def pin_mtimes(root)
    stamp = Time.local(2026, 7, 10, 12, 0, 0)
    Dir.glob(File.join(root, "**", "*"), File::FNM_DOTMATCH).each do |path|
      File.utime(stamp, stamp, path) if File.file?(path)
    end
  end

  def write_consistent_vault(root)
    write(root, "raw/internal.txt", "The founder chose a publishing cadence.")
    write(root, "wiki/research/channel.md", <<~MARKDOWN)
      ---
      type: research
      title: Channel evidence
      status: high
      created: 2026-07-10
      updated: 2026-07-10
      ---
      Checked channel evidence supports the experiment.
    MARKDOWN
    write(root, "log.md", <<~MARKDOWN)
      # Log
      ## [2026-07-10] plan | Publish weekly
      ## [2026-07-10] sprint | Draft the first post
    MARKDOWN
    write(root, "queue.md", "# Queue\n\n## Queue\n")
    write(root, "index.md", <<~MARKDOWN)
      # Index
      ## Initiatives
      - [Publish weekly](wiki/initiatives/publish-weekly.md) [state: executing] [roadmap: 1/2]
    MARKDOWN
    write(root, "hub/initiatives.md", <<~MARKDOWN)
      ---
      type: business
      title: Initiative map
      status: high
      created: 2026-07-10
      updated: 2026-07-10
      ---
      # Initiatives
      ## Idea
      ## Survived
      ## Planned
      ## Executing
      - [Publish weekly](../wiki/initiatives/publish-weekly.md)
      ## Reviewed
      ## Banked
    MARKDOWN
    write(root, "baton.md", <<~MARKDOWN)
      ---
      type: baton
      updated: 2026-07-10
      active_initiative: wiki/initiatives/publish-weekly.md
      initiative_state: executing
      roadmap_done: 1
      roadmap_total: 2
      next_step: Publish the first post.
      content: {}
      ---
      # Baton
      The next move is to publish the first post.
    MARKDOWN
    write(root, "wiki/initiatives/publish-weekly.md", <<~MARKDOWN)
      ---
      type: initiative
      title: Publish weekly
      state: executing
      size: small
      status: stated
      created: 2026-07-10
      updated: 2026-07-10
      reopens: null
      internal_receipt: raw/internal.txt#founder chose a publishing cadence
      external_receipt: wiki/research/channel.md#Checked channel evidence
      ---
      # Publish weekly
      ## Roadmap
      ### Next steps
      - [x] Draft the first post.
      - [ ] Publish the first post.
      ## Log
      - [2026-07-10] sprint: draft completed
    MARKDOWN
    pin_mtimes(root)
  end

  def run_audit(root, *files)
    Open3.capture3(AUDIT, "--root", root, *files)
  end

  def test_accepts_consistent_lifecycle_graph
    with_vault do |root|
      write_consistent_vault(root)

      _out, err, status = run_audit(root)
      assert status.success?, err
    end
  end

  def test_rejects_lifecycle_projection_and_stale_baton_disagreement
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      File.write(path, File.read(path).sub("state: executing", "state: planned"))

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "state projection disagrees"
      assert_includes err, "expected planned"
      assert_includes err, "initiative_state disagrees with planned"
    end
  end

  def test_rejects_pending_queue_item_that_survived_a_health_pass
    with_vault do |root|
      write_consistent_vault(root)
      File.open(File.join(root, "log.md"), "a") { |file| file << "## [2026-07-10] lint | health pass\n" }
      write(root, "queue.md", <<~MARKDOWN)
        # Queue
        ## Queue
        ### Q-20260710-001
        - status: pending
        - from: recall
        - to: steward
        - created: 2026-07-10
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "pending Q-20260710-001 survived health pass"
    end
  end

  def test_rejects_durable_initiative_created_without_root_event
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "log.md", "# Log\n## [2026-07-10] sprint | Draft the first post\n")

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "durable initiative creation has no matching 2026-07-10 offer/gauntlet/plan event row"
    end
  end

  def test_rejects_stale_updated_metadata_after_later_dated_mutation
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      File.open(path, "a") { |file| file << "- [2026-07-17] review: outcome recorded\n" }

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "updated 2026-07-10 is stale; body records 2026-07-17"
    end
  end

  def test_rejects_content_projection_drift_and_unmet_checked_step
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "wiki/business/content/post-one.md", <<~MARKDOWN)
        ---
        type: content
        title: Post one
        status: stated
        content_state: draft
        channel: writing
        published_at: null
        initiative: wiki/initiatives/publish-weekly.md
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Post one
        Draft copy.
      MARKDOWN
      File.open(File.join(root, "log.md"), "a") { |file| file << "## [2026-07-10] content | Post one\n" }
      File.open(File.join(root, "index.md"), "a") do |file|
        file << "- [Post one](wiki/business/content/post-one.md) [content_state: draft]\n"
      end
      write(root, "hub/business.md", <<~MARKDOWN)
        ---
        type: business
        title: Business map
        status: high
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Business
        ## Content
        - [Post one](../wiki/business/content/post-one.md) [content_state: published]
      MARKDOWN
      baton = File.read(File.join(root, "baton.md")).sub(
        "content: {}",
        <<~YAML.strip
          content:
            wiki/business/content/post-one.md:
              content_state: approved
              published_at:
        YAML
      )
      File.write(File.join(root, "baton.md"), baton)
      initiative = File.read(File.join(root, "wiki/initiatives/publish-weekly.md")).sub(
        "Draft the first post.",
        "Draft and approve the first post."
      )
      File.write(File.join(root, "wiki/initiatives/publish-weekly.md"), initiative)

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "baton.md: wiki/business/content/post-one.md content_state is stale"
      assert_includes err, "checked approval step is unmet"
      assert_includes err, "hub/business.md"
    end
  end

  def test_rejects_offer_state_without_offer_event
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "wiki/business/offer.md", <<~MARKDOWN)
        ---
        type: business
        title: Current offer
        status: stated
        offer_state: approved
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Offer
        ## Price
        EUR 800/month.
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "durable offer state has no matching 2026-07-10 offer event row"
    end
  end

  def test_rejects_any_non_idea_work_without_checked_receipt_legs
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      text = File.read(path)
        .sub("title: Publish weekly", "title: Maintain notes")
        .sub("# Publish weekly", "# Maintain notes")
        .gsub(/publish/i, "maintain")
        .lines.reject { |line| line.start_with?("internal_receipt:", "external_receipt:") }.join
      File.write(path, text)

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "executing initiative needs internal_receipt"
      assert_includes err, "executing initiative needs external_receipt"
    end
  end

  def test_rejects_wrong_receipt_kinds
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      text = File.read(path)
        .sub("raw/internal.txt#founder chose a publishing cadence", "wiki/initiatives/publish-weekly.md#Publish weekly")
        .sub("wiki/research/channel.md#Checked channel evidence", "wiki/initiatives/publish-weekly.md#Publish weekly")
      File.write(path, text)

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "internal_receipt cannot point to initiative or content output"
      assert_includes err, "external_receipt must point to dated wiki/research evidence"
    end
  end

  def test_creation_event_must_match_title_and_created_date_exactly
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "log.md", <<~MARKDOWN)
        # Log
        ## [2026-07-09] plan | Publish weekly later
        ## [2026-07-10] sprint | Draft the first post
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "durable initiative creation has no matching 2026-07-10"
    end
  end

  def test_offer_event_must_match_current_updated_date
    with_vault do |root|
      write_consistent_vault(root)
      File.open(File.join(root, "log.md"), "a") { |file| file << "## [2026-07-09] offer | Current offer\n" }
      write(root, "wiki/business/offer.md", <<~MARKDOWN)
        ---
        type: business
        title: Current offer
        status: stated
        offer_state: approved
        created: 2026-07-09
        updated: 2026-07-10
        ---
        # Offer
        ## Price
        Founder-stated price.
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "has no matching 2026-07-10 offer event row"
    end
  end

  def test_full_audit_rejects_frontmatter_older_than_file_mtime
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      text = File.read(path).sub("updated: 2026-07-10", "updated: 2026-07-09")
      File.write(path, text)
      timestamp = Time.local(2026, 7, 10, 12, 0, 0)
      File.utime(timestamp, timestamp, path)

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "updated 2026-07-09 predates file modification 2026-07-10"
    end
  end

  def test_future_deadline_is_not_treated_as_a_file_mutation
    with_vault do |root|
      write_consistent_vault(root)
      path = File.join(root, "wiki", "initiatives", "publish-weekly.md")
      File.open(path, "a") { |file| file << "Review deadline: 2026-07-17.\n" }
      pin_mtimes(root)

      _out, err, status = run_audit(root)
      assert status.success?, err
    end
  end

  def test_rejects_cleared_vision_strategy_without_checked_receipt_legs
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "wiki/business/vision.md", <<~MARKDOWN)
        ---
        type: business
        title: Vision
        status: stated
        strategy_state: cleared
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Vision
        ## Direction
        Publish proof in the founder's own name.
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "cleared strategy needs internal_receipt"
      assert_includes err, "cleared strategy needs external_receipt"
    end
  end

  def test_rejects_published_unverified_copy_and_missing_founder_receipts
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "wiki/business/content/post-one.md", <<~MARKDOWN)
        ---
        type: content
        title: Post one
        status: stated
        content_state: published
        channel: writing
        published_at: 2026-07-10
        initiative: wiki/initiatives/publish-weekly.md
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Post one
        Most founders spend their nerve on product. [unverified]
      MARKDOWN
      File.open(File.join(root, "log.md"), "a") { |file| file << "## [2026-07-10] content | Post one\n" }
      File.open(File.join(root, "index.md"), "a") do |file|
        file << "- [Post one](wiki/business/content/post-one.md) [content_state: published]\n"
      end
      write(root, "hub/business.md", <<~MARKDOWN)
        ---
        type: business
        title: Business map
        status: high
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Business
        ## Content
        - [Post one](../wiki/business/content/post-one.md) [content_state: published]
      MARKDOWN
      baton = File.read(File.join(root, "baton.md")).sub(
        "content: {}",
        <<~YAML.strip
          content:
            wiki/business/content/post-one.md:
              content_state: published
              published_at: 2026-07-10
        YAML
      )
      File.write(File.join(root, "baton.md"), baton)

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "published content contains [unverified] copy"
      assert_includes err, "published content needs approval_receipt"
      assert_includes err, "published content needs publication_receipt"
    end
  end

  def test_rejects_founder_approval_receipt_outside_immutable_inbox
    with_vault do |root|
      write_consistent_vault(root)
      write(root, "wiki/business/content/post-one.md", <<~MARKDOWN)
        ---
        type: content
        title: Post one
        status: stated
        content_state: approved
        channel: writing
        published_at: null
        approval_receipt: raw/internal.txt#founder chose a publishing cadence
        initiative: wiki/initiatives/publish-weekly.md
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Post one
        Founder-approved copy.
      MARKDOWN
      File.open(File.join(root, "log.md"), "a") { |file| file << "## [2026-07-10] content | Post one\n" }
      File.open(File.join(root, "index.md"), "a") do |file|
        file << "- [Post one](wiki/business/content/post-one.md) [content_state: approved]\n"
      end
      write(root, "hub/business.md", <<~MARKDOWN)
        ---
        type: business
        title: Business map
        status: high
        created: 2026-07-10
        updated: 2026-07-10
        ---
        # Business
        ## Content
        - [Post one](../wiki/business/content/post-one.md) [content_state: approved]
      MARKDOWN

      _out, err, status = run_audit(root)
      refute status.success?
      assert_includes err, "approval_receipt must point to immutable raw/inbox evidence"
    end
  end
end
