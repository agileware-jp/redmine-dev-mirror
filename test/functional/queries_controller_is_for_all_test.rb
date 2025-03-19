# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-  Jean-Philippe Lang
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

class QueriesControllerIsForAllTest < Redmine::ControllerTest
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses, :trackers,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers, :queries

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
    @controller = QueriesController.new
  end

  def test_new_query_is_for_all_checkbox_not_disabled
    get :new
    assert_response :success
    # Verify that the "For all projects" checkbox is not disabled when creating a new query
    assert_select 'input[name=query_is_for_all][type=checkbox][checked]:not([disabled])'
  end

  def test_new_project_query_is_for_all_checkbox_not_disabled
    get(:new, :params => {:project_id => 1})
    assert_response :success
    # Verify that the checkbox is not disabled when creating a new query within a project
    assert_select 'input[name=query_is_for_all][type=checkbox]:not([checked]):not([disabled])'
  end

  def test_edit_global_query_is_for_all_checkbox_disabled
    # Create a global query (project_id = nil)
    query = IssueQuery.create!(:name => 'test_global_query', :user_id => 1, :project_id => nil)

    get(:edit, :params => {:id => query.id})
    assert_response :success

    # Verify that the "For all projects" checkbox is disabled when editing an existing global query
    assert_select 'input[name=query_is_for_all][type=checkbox][checked][disabled]'
  end

  def test_edit_project_query_is_for_all_checkbox_not_disabled
    # Create a project-specific query
    query = IssueQuery.create!(:name => 'test_project_query', :user_id => 1, :project_id => 1)

    get(:edit, :params => {:id => query.id})
    assert_response :success

    # Verify that the checkbox is not disabled when editing a project-specific query
    assert_select 'input[name=query_is_for_all][type=checkbox]:not([checked]):not([disabled])'
  end
end
