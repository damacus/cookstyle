#!/bin/sh

############################################################################
# What is this script?
#
# Cookstyle includes a docs directory with content that is autogenerated by
# a rake task. This ensures that all cop documentation is current on each
# merge to the repo. We live in the future.
############################################################################

bundle install --jobs=7 --retry=3 --without debug profiling
bundle exec rake generate_cops_yml_documentation
bundle exec rake update_readme_cop_count

# Once Expeditor finishes executing this script, it will commit the changes and push
