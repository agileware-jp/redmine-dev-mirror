# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-2023  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require_relative '../test_helper'
require_relative '../../lib/generators/redmine_plugin_model/redmine_plugin_model_generator'

class ModelGeneratorTest < Rails::Generators::TestCase
  TMP_DIR = Rails.root / 'tmp/test/generators'

  tests RedminePluginModelGenerator
  destination TMP_DIR
  setup :prepare_destination

  setup do
    @plugin_directory = Redmine::Plugin.directory
    Redmine::Plugin.directory = TMP_DIR
  end

  teardown do
    Redmine::Plugin.directory = @plugin_directory
  end

  def test_no_add_index_with_references
    g = generator ['ModelDemo', 'SandboxModel', 'issue:references', 'project:belongs_to']

    capture(:stdout) do
      g.invoke_all
    end

    path_names = (Redmine::Plugin.directory / 'model_demo/db/migrate')
      .glob('*_create_sandbox_models.rb')
    assert_equal 1, path_names.count

    migration = path_names.first.read

    assert_match %r{t\.references :issue, foreign_key: true}, migration
    assert_match %r{t\.belongs_to :project, foreign_key: true}, migration
    assert_no_match %r{add_index}, path_names.first.read
  end
end
