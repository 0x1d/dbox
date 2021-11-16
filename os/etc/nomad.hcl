#  Notes about <literal>data_dir</literal>:
#
#  If <literal>data_dir</literal> is set to a value other than the
#  default value of <literal>"/var/lib/nomad"</literal> it is the Nomad
#  cluster manager's responsibility to make sure that this directory
#  exists and has the appropriate permissions.
#
#  Additionally, if <literal>dropPrivileges</literal> is
#  <literal>true</literal> then <literal>data_dir</literal>
#  <emphasis>cannot</emphasis> be customized. Setting
#  <literal>dropPrivileges</literal> to <literal>true</literal> enables
#  the <literal>DynamicUser</literal> feature of systemd which directly
#  manages and operates on <literal>StateDirectory</literal>.

#data_dir  = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

advertise {
  # Defaults to the first private IP address.
  http = "1.2.3.4"
  rpc  = "1.2.3.4"
  serf = "1.2.3.4:5648" # non-default ports may be specified
}

server {
  enabled          = true
  bootstrap_expect = 3
}

client {
  enabled       = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address = "1.2.3.4:8500"
}

