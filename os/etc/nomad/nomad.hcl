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

data_dir  = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled       = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {
    enabled = true
  }
}

#consul {
#  address = "10.0.42.1:8500"
#}

