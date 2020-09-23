# frozen_string_literal: true
#
# Copyright:: 2019, Chef Software Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module RuboCop
  module Cop
    module Chef
      module ChefSharing
        # metadata.rb license field should include a SPDX compliant string or "all right reserved" (not case sensitive)
        #
        # @example
        #
        #   # bad
        #   license 'Apache 2.0'
        #
        #   # good
        #   license 'Apache-2.0'
        #   license 'all rights reserved'
        #
        # list of valid SPDX.org license strings. To build an array run this:
        # require 'json'
        # require 'net/http'
        # json_data = JSON.parse(Net::HTTP.get(URI('https://raw.githubusercontent.com/spdx/license-list-data/master/json/licenses.json')))
        # licenses = json_data['licenses'].map {|l| l['licenseId'] }.sort
        #
        class InvalidLicenseString < Base
          extend AutoCorrector

          VALID_LICENSE_STRING = %w(
            0BSD
            AAL
            ADSL
            AFL-1.1
            AFL-1.2
            AFL-2.0
            AFL-2.1
            AFL-3.0
            AGPL-1.0
            AGPL-1.0-only
            AGPL-1.0-or-later
            AGPL-3.0
            AGPL-3.0-only
            AGPL-3.0-or-later
            AMDPLPA
            AML
            AMPAS
            ANTLR-PD
            APAFML
            APL-1.0
            APSL-1.0
            APSL-1.1
            APSL-1.2
            APSL-2.0
            Abstyles
            Adobe-2006
            Adobe-Glyph
            Afmparse
            Aladdin
            Apache-1.0
            Apache-1.1
            Apache-2.0
            Artistic-1.0
            Artistic-1.0-Perl
            Artistic-1.0-cl8
            Artistic-2.0
            BSD-1-Clause
            BSD-2-Clause
            BSD-2-Clause-FreeBSD
            BSD-2-Clause-NetBSD
            BSD-2-Clause-Patent
            BSD-3-Clause
            BSD-3-Clause-Attribution
            BSD-3-Clause-Clear
            BSD-3-Clause-LBNL
            BSD-3-Clause-No-Nuclear-License
            BSD-3-Clause-No-Nuclear-License-2014
            BSD-3-Clause-No-Nuclear-Warranty
            BSD-3-Clause-Open-MPI
            BSD-4-Clause
            BSD-4-Clause-UC
            BSD-Protection
            BSD-Source-Code
            BSL-1.0
            Bahyph
            Barr
            Beerware
            BitTorrent-1.0
            BitTorrent-1.1
            BlueOak-1.0.0
            Borceux
            CATOSL-1.1
            CC-BY-1.0
            CC-BY-2.0
            CC-BY-2.5
            CC-BY-3.0
            CC-BY-4.0
            CC-BY-NC-1.0
            CC-BY-NC-2.0
            CC-BY-NC-2.5
            CC-BY-NC-3.0
            CC-BY-NC-4.0
            CC-BY-NC-ND-1.0
            CC-BY-NC-ND-2.0
            CC-BY-NC-ND-2.5
            CC-BY-NC-ND-3.0
            CC-BY-NC-ND-4.0
            CC-BY-NC-SA-1.0
            CC-BY-NC-SA-2.0
            CC-BY-NC-SA-2.5
            CC-BY-NC-SA-3.0
            CC-BY-NC-SA-4.0
            CC-BY-ND-1.0
            CC-BY-ND-2.0
            CC-BY-ND-2.5
            CC-BY-ND-3.0
            CC-BY-ND-4.0
            CC-BY-SA-1.0
            CC-BY-SA-2.0
            CC-BY-SA-2.5
            CC-BY-SA-3.0
            CC-BY-SA-4.0
            CC-PDDC
            CC0-1.0
            CDDL-1.0
            CDDL-1.1
            CDLA-Permissive-1.0
            CDLA-Sharing-1.0
            CECILL-1.0
            CECILL-1.1
            CECILL-2.0
            CECILL-2.1
            CECILL-B
            CECILL-C
            CERN-OHL-1.1
            CERN-OHL-1.2
            CNRI-Jython
            CNRI-Python
            CNRI-Python-GPL-Compatible
            CPAL-1.0
            CPL-1.0
            CPOL-1.02
            CUA-OPL-1.0
            Caldera
            ClArtistic
            Condor-1.1
            Crossword
            CrystalStacker
            Cube
            D-FSL-1.0
            DOC
            DSDP
            Dotseqn
            ECL-1.0
            ECL-2.0
            EFL-1.0
            EFL-2.0
            EPL-1.0
            EPL-2.0
            EUDatagrid
            EUPL-1.0
            EUPL-1.1
            EUPL-1.2
            Entessa
            ErlPL-1.1
            Eurosym
            FSFAP
            FSFUL
            FSFULLR
            FTL
            Fair
            Frameworx-1.0
            FreeImage
            GFDL-1.1
            GFDL-1.1-only
            GFDL-1.1-or-later
            GFDL-1.2
            GFDL-1.2-only
            GFDL-1.2-or-later
            GFDL-1.3
            GFDL-1.3-only
            GFDL-1.3-or-later
            GL2PS
            GPL-1.0
            GPL-1.0+
            GPL-1.0-only
            GPL-1.0-or-later
            GPL-2.0
            GPL-2.0+
            GPL-2.0-only
            GPL-2.0-or-later
            GPL-2.0-with-GCC-exception
            GPL-2.0-with-autoconf-exception
            GPL-2.0-with-bison-exception
            GPL-2.0-with-classpath-exception
            GPL-2.0-with-font-exception
            GPL-3.0
            GPL-3.0+
            GPL-3.0-only
            GPL-3.0-or-later
            GPL-3.0-with-GCC-exception
            GPL-3.0-with-autoconf-exception
            Giftware
            Glide
            Glulxe
            HPND
            HPND-sell-variant
            HaskellReport
            IBM-pibs
            ICU
            IJG
            IPA
            IPL-1.0
            ISC
            ImageMagick
            Imlib2
            Info-ZIP
            Intel
            Intel-ACPI
            Interbase-1.0
            JPNIC
            JSON
            JasPer-2.0
            LAL-1.2
            LAL-1.3
            LGPL-2.0
            LGPL-2.0+
            LGPL-2.0-only
            LGPL-2.0-or-later
            LGPL-2.1
            LGPL-2.1+
            LGPL-2.1-only
            LGPL-2.1-or-later
            LGPL-3.0
            LGPL-3.0+
            LGPL-3.0-only
            LGPL-3.0-or-later
            LGPLLR
            LPL-1.0
            LPL-1.02
            LPPL-1.0
            LPPL-1.1
            LPPL-1.2
            LPPL-1.3a
            LPPL-1.3c
            Latex2e
            Leptonica
            LiLiQ-P-1.1
            LiLiQ-R-1.1
            LiLiQ-Rplus-1.1
            Libpng
            Linux-OpenIB
            MIT
            MIT-0
            MIT-CMU
            MIT-advertising
            MIT-enna
            MIT-feh
            MITNFA
            MPL-1.0
            MPL-1.1
            MPL-2.0
            MPL-2.0-no-copyleft-exception
            MS-PL
            MS-RL
            MTLL
            MakeIndex
            MirOS
            Motosoto
            Multics
            Mup
            NASA-1.3
            NBPL-1.0
            NCSA
            NGPL
            NLOD-1.0
            NLPL
            NOSL
            NPL-1.0
            NPL-1.1
            NPOSL-3.0
            NRL
            NTP
            Naumen
            Net-SNMP
            NetCDF
            Newsletr
            Nokia
            Noweb
            Nunit
            OCCT-PL
            OCLC-2.0
            ODC-By-1.0
            ODbL-1.0
            OFL-1.0
            OFL-1.1
            OGL-UK-1.0
            OGL-UK-2.0
            OGL-UK-3.0
            OGTSL
            OLDAP-1.1
            OLDAP-1.2
            OLDAP-1.3
            OLDAP-1.4
            OLDAP-2.0
            OLDAP-2.0.1
            OLDAP-2.1
            OLDAP-2.2
            OLDAP-2.2.1
            OLDAP-2.2.2
            OLDAP-2.3
            OLDAP-2.4
            OLDAP-2.5
            OLDAP-2.6
            OLDAP-2.7
            OLDAP-2.8
            OML
            OPL-1.0
            OSET-PL-2.1
            OSL-1.0
            OSL-1.1
            OSL-2.0
            OSL-2.1
            OSL-3.0
            OpenSSL
            PDDL-1.0
            PHP-3.0
            PHP-3.01
            Parity-6.0.0
            Plexus
            PostgreSQL
            Python-2.0
            QPL-1.0
            Qhull
            RHeCos-1.1
            RPL-1.1
            RPL-1.5
            RPSL-1.0
            RSA-MD
            RSCPL
            Rdisc
            Ruby
            SAX-PD
            SCEA
            SGI-B-1.0
            SGI-B-1.1
            SGI-B-2.0
            SHL-0.5
            SHL-0.51
            SISSL
            SISSL-1.2
            SMLNJ
            SMPPL
            SNIA
            SPL-1.0
            SSPL-1.0
            SWL
            Saxpath
            Sendmail
            Sendmail-8.23
            SimPL-2.0
            Sleepycat
            Spencer-86
            Spencer-94
            Spencer-99
            StandardML-NJ
            SugarCRM-1.1.3
            TAPR-OHL-1.0
            TCL
            TCP-wrappers
            TMate
            TORQUE-1.1
            TOSL
            TU-Berlin-1.0
            TU-Berlin-2.0
            UPL-1.0
            Unicode-DFS-2015
            Unicode-DFS-2016
            Unicode-TOU
            Unlicense
            VOSTROM
            VSL-1.0
            Vim
            W3C
            W3C-19980720
            W3C-20150513
            WTFPL
            Watcom-1.0
            Wsuipa
            X11
            XFree86-1.1
            XSkat
            Xerox
            Xnet
            YPL-1.0
            YPL-1.1
            ZPL-1.1
            ZPL-2.0
            ZPL-2.1
            Zed
            Zend-2.0
            Zimbra-1.3
            Zimbra-1.4
            Zlib
            blessing
            bzip2-1.0.5
            bzip2-1.0.6
            copyleft-next-0.3.0
            copyleft-next-0.3.1
            curl
            diffmark
            dvipdfm
            eCos-2.0
            eGenix
            gSOAP-1.3b
            gnuplot
            iMatix
            libpng-2.0
            libtiff
            mpich2
            psfrag
            psutils
            wxWindows
            xinetd
            xpp
            zlib-acknowledgement
          ).freeze

          COMMON_TYPOS = {
            "all_rights": 'all rights reserved',
            "apache 2.0": 'Apache-2.0',
            "apache v2": 'Apache-2.0',
            "apache v2.0": 'Apache-2.0',
            "apache license version 2.0": 'Apache-2.0',
            "apache2": 'Apache-2.0',
            "mit": 'MIT',
            '3-clause bsd': 'BSD-3-Clause',
            'gnu public license 3.0': 'GPL-3.0',
            'gpl v2': 'GPL-2.0',
            'gpl v3': 'GPL-3.0',
            'gplv2': 'GPL-2.0',
            'gplv3': 'GPL-3.0',
            'mit license': 'MIT',
            'UNLICENSED': 'all rights reserved',
          }.freeze

          MSG = 'Cookbook metadata.rb does not use a SPDX compliant license string or "all rights reserved". See https://spdx.org/licenses/ for a complete list of license identifiers.'
          RESTRICT_ON_SEND = [:license].freeze

          def_node_matcher :license?, '(send nil? :license $str ...)'

          def on_send(node)
            license?(node) do |license|
              return if valid_license?(license.str_content)
              add_offense(license, message: MSG, severity: :refactor) do |corrector|
                correct_string = autocorrect_license_string(license.str_content)
                corrector.replace(license, "'#{correct_string}'") if correct_string
              end
            end
          end

          # private

          def autocorrect_license_string(bad_string)
            COMMON_TYPOS[bad_string.delete(',').downcase.to_sym]
          end

          def valid_license?(license)
            VALID_LICENSE_STRING.include?(license) ||
              license.casecmp('all rights reserved') == 0
          end
        end
      end
    end
  end
end
