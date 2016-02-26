# Sometimes its a README fix, or something like that - which isn't relevant for
# including in a CHANGELOG for example
declared_trivial = pr_title.include? "#trivial"

# Just to let people know
warn("PR is classed as Work in Progress") if pr_title.include? "[WIP]"

# Oi, CHANGELOGs please
fail("No CHANGELOG changes made") if lines_of_code > 50 && !files_modified.include?("CHANGELOG.yml") && !declared_trivial

# Stop skipping some manual testing
warn("Needs testing on a Phone if change is non-trivial") if lines_of_code > 50 && !pr_title.include?("📱")

# Don't let testing shortcuts get into master
fail("fdescribe left in tests") if `grep -r fdescribe Artsy_Tests/`.length > 1
fail("fit left in tests") if `grep -r "fit(@" Artsy_Tests/`.length > 1

# Devs shouldn't ship changes to this file
fail("Developer Specific file shouldn't be changed") if files_modified.include?("Artsy/View_Controllers/App_Navigation/ARTopMenuViewController+DeveloperExtras.m")

# Did you make analytics changes? Well you should also include a change to our analytics spec
made_analytics_changes = files_modified.include?("/Artsy/App/ARAppDelegate+Analytics.m")
made_analytics_specs_changes = files_modified.include?("/Artsy_Tests/Analytics_Tests/ARAppAnalyticsSpec.m")
if made_analytics_changes
    fail("Analytics changes should have reflected specs changes") if !made_analytics_specs_changes

    # And pay extra attention anyway
    message('Analytics dict changed, double check for ?: `@""` on new entries')
    message('Also, double check the [Analytics Eigen schema](https://docs.google.com/spreadsheets/u/1/d/1bLbeOgVFaWzLSjxLOBDNOKs757-zBGoLSM1lIz3OPiI/edit#gid=497747862) if the changes are non-trivial.')
end


# CHANGELOG should lint
require "YAML"
begin
  readme_yaml = File.read "CHANGELOG.yml"
  readme_data = YAML.load readme_yaml
rescue e
  fail("CHANGELOG isn't legit YAML")
end

# So if there's snapshot fails, we should also fail danger, but we can make the thing clickable in a comment instead of hidden in the log
# Note: this may break in a future build of Danger, I am debating sandboxing the runner from ENV vars.
build_log = File.read( File.join(ENV["CIRCLE_ARTIFACTS"], "xcode_test_raw.log") )
snapshots_url = build_log.match(%r{https://eigen-ci.s3.amazonaws.com/\d+/index.html})
fail("There were [snapshot errors](#{snapshots_url})") if snapshots_url

# Look for unstubbed networking requests, as these can be a source of test flakiness
unstubbed_regex = /   Inside Test: -\[(\w+) (\w+)/m
if build_log.match(unstubbed_regex)
  output = "#### Found unstubbbed networking requests\n"
  build_log.scan(unstubbed_regex).each do |class_and_test|
    class_name = class_and_test[0]
    url = "https://github.com/search?q=#{class_name.gsub("Spec", "")}+repo%3Aartsy%2Feigen&ref=searchresults&type=Code&utf8=✓"
    output += "\n* [#{class_name}](#{url}) in `#{class_and_test[1]}`"
  end
  warn(output)
end
