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

desc 'Generates a secret token for the application.'

file 'config/initializers/secret_token.rb' do
  path = File.join(Rails.root, 'config', 'initializers', 'secret_token.rb')
  secret = SecureRandom.hex(40)
  File.open(path, 'w') do |f|
    f.write <<"EOF"
# frozen_string_literal: true

# This file was generated by 'rake generate_secret_token', and should
# not be made visible to public.
# If you have a load-balancing Redmine cluster, you will need to use the
# same version of this file on each machine. And be sure to restart your
# server when you modify this file.
#
# Your secret key for verifying cookie session data integrity. If you
# change this key, all old sessions will become invalid! Make sure the
# secret is at least 30 characters and all random, no regular words or
# you'll be exposed to dictionary attacks.
RedmineApp::Application.config.secret_key_base = '#{secret}'
EOF
  end
end

desc 'Generates a secret token for the application.'
task :generate_secret_token => ['config/initializers/secret_token.rb']
