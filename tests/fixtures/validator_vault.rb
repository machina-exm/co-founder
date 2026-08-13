# frozen_string_literal: true

require "fileutils"

module ValidatorVaultFixture
  module_function

  FIXTURE_DATE = "2026-07-10"

  def write(root, path, content)
    target = File.join(root, path)
    FileUtils.mkdir_p(File.dirname(target))
    File.write(target, content)
  end

  # Pin every file's mtime to the fixture date so graph-audit's "updated predates file
  # modification" check reflects the fixture's intent rather than the day the test runs.
  def pin_mtimes(root)
    stamp = Time.local(2026, 7, 10, 12, 0, 0)
    Dir.glob(File.join(root, "**", "*"), File::FNM_DOTMATCH).each do |path|
      File.utime(stamp, stamp, path) if File.file?(path)
    end
  end

  def build(root, broken: false)
    FileUtils.rm_rf(root)
    FileUtils.mkdir_p(root)
    FileUtils.mkdir_p(File.join(root, "raw", "inbox"))
    FileUtils.mkdir_p(File.join(root, "wiki", "initiatives"))
    FileUtils.mkdir_p(File.join(root, "wiki", "business", "content"))
    FileUtils.mkdir_p(File.join(root, "hub"))

    write(root, "AGENTS.md", "# Fixture founder system\n\nUse the deterministic filing gate.\n")
    write(root, "raw/inbox/interview.txt", "The founder confirmed the pilot price.")
    write(root, "raw/inbox/cadence.txt", "The founder chose the publishing cadence.")
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
      ## Business
      - [Claim check](wiki/business/claim.md)
      ## Initiatives
      - [Publish weekly](wiki/initiatives/publish-weekly.md) [state: executing] [roadmap: 1/2]
    MARKDOWN
    write(root, "baton.md", <<~MARKDOWN)
      ---
      type: baton
      updated: 2026-07-10
      active_initiative: wiki/initiatives/publish-weekly.md
      initiative_state: #{broken ? "planned" : "executing"}
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
      internal_receipt: raw/inbox/cadence.txt#chose the publishing cadence
      external_receipt: wiki/research/channel.md#Checked channel evidence
      ---
      # Publish weekly
      ## Roadmap
      ### Next steps
      - [x] Draft the first post.
      - [ ] Publish the first post.
      ## Log
      - [2026-07-10] sprint: draft completed
      #{broken ? "- [2026-07-17] review: later mutation" : ""}
    MARKDOWN
    # A durable body carrying an inline receipt exercises the quote-on-cite check. In broken mode the
    # cited anchor is not present in the source file, so graph-audit rejects it.
    receipt_anchor = broken ? "slashed the pilot price" : "confirmed the pilot price"
    write(root, "wiki/business/claim.md", <<~MARKDOWN)
      ---
      type: business
      title: Claim check
      status: stated
      created: 2026-07-10
      updated: 2026-07-10
      ---
      # Claim check
      The pilot price is recorded. [receipt: raw/inbox/interview.txt##{receipt_anchor}]
      The campaign duration is not recorded.
    MARKDOWN
    write(root, "wiki/business/offer.md", <<~MARKDOWN)
      ---
      type: business
      title: Current offer
      status: stated
      offer_state: draft
      created: 2026-07-10
      updated: 2026-07-10
      ---
      # Offer
      ## Audience
      None yet.
      ## Promise
      None yet.
      ## Ladder and price
      None yet.
      ## Terms and receipts
      None yet.
      ## Parked recommendations
      None.
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
    %w[business learnings sops research decisions people].each do |name|
      write(root, "hub/#{name}.md", "# #{name.capitalize}\n") unless File.exist?(File.join(root, "hub", "#{name}.md"))
    end

    if broken
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
    end

    pin_mtimes(root)
  end
end
