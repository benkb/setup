# libary functions around internet and file urls
#
# todo:
# perl regex urls
# https://gist.github.com/GuillaumeLestringant/36c11afcc35c8c5b9123

set -eu

prn() { printf "%s" "$*"; }
fail() { echo "Fail: $*" >&2; }
info() { echo "$@" >&2; }
die() {
	echo "$@" >&2
	exit 1
}

absdir() { (cd "${1}" && pwd -P); }
stamp() { date +'%Y%m%d%H%M%S'; }


utils_liburl__get_url(){
    local item="${1:-}"
    if [ -z "$item" ]; then
        fail "no valid input '$item'"
        return 1
    fi
    if [ -f "$item" ]; then
        utils_liburl__get_fileurl "$item" 
    else
        case "$item" in
            'http://'*|'https://'*|'file://'*) prn "$item" ;;
            *.*)
                local url=
                if perl -e '$ARGV[0] =~ /^[a-zA-Z0-9\/]+\.[a-z]+$/ || exit 1' "$item"; then
                    if url="$(utils_liburl__get_fileurl "$item")" 2>/dev/null ; then
                        prn "$url"
                    else
                        utils_liburl__get_web_address "$item"
                    fi
                else
                    utils_liburl__get_web_address "$item"
                fi
                ;;
            *)
                fail "its not looking like an item for url '$item'"
                return 1
                ;;
        esac
    fi
}

utils_liburl__get_fileurl() {
    local file="${1:-}"
    if [ -z "$file" ]; then
        fail "no valid input '$file'"
        return 1
    fi
    [ -f "$file" ] || {
        fail "(utils_liburl__get_fileurl): not a valid file '$file'"
        return 1
    }


    local file_dir=;
    file_dir="$(dirname "$file")"
    local file_dir_abs=;
    file_dir_abs="$(absdir "$file_dir")" 

    local filename="${file##*/}"
    local file_abspath="$file_dir_abs/$filename"

    echo "file://$file_abspath"


}


utils_liburl__get_domain(){
    local url="${1:-}"
    if [ -z "$url" ] ; then
        fail 'url is missing'
        return 1
    fi

    local prelude='$ARGV[0] =~ '
    local finale='(?:[^.\/]+[.])*([^\/.]+[.][^\/.]+)\/?/ &&  print $1;'

    local domain=
    case "$url" in
        'https://'*|'http://'*|'file://'*) 
            domain="$(perl -e "${prelude}/\/\/${finale}" "$url")" 
            ;;
        *) 
            domain="$(perl -e "${prelude}/${finale}" "$url")" 
            ;;
    esac

    if [ -n "$domain" ] ; then
        prn "$domain"
    else
        fail "could not fetch domain for url '$url'"
        return 1
    fi
}

utils_liburl__get_web_address(){
    local item="${1:-}"
    if [ -z "$item" ] ; then
        fail 'item is missing'
        return 1
    fi

    local address=
    case "$item" in
        http*|'file://'*) address="$item" ;;
        [a-zA-Z0-9]*.*)  # if the input is missing the protocol part
            local domain=
            domain="$(utils_liburl__get_domain "$item")" 

            if utils_liburl__urlext_big "$domain" ; then
                address="http://$item" 
            else
                fail "(get_web_address): does not look like url '$item'"
                return 1
            fi
            ;;
        *)
            fail "(get_web_address): does not look like url '$item'"
            return 1
            ;;
    esac


    if [ -n "$address" ] ; then
        prn "$address"
        return 0
    else
        fail '(webloc__get_web_address): could not get address'
        return 1
    fi

}

utils_liburl__get_title(){
    local url="${1:-}"
    if [ -z "$url" ] ; then
        fail 'no url'
        return 1
    fi

    local title=
    for plcode in  '/\<h1\>([^\<]*)\<\/h1/ && print $1' '/\<title\>([^\<]*)\<\/title/ && print $1'; do
        if title="$(curl -L "$url" 2>/dev/null| perl -ne "$plcode")" ; then
            if [ -n "$title" ] ; then
                break
            fi
        fi
    done

    if [ -n "$title" ] ; then
        prn "$title"
    else
        fail "could not get title for url '$url'"
        return 1
    fi
}

utils_liburl__aux_clean_string(){
    local string="${1:-}"
    if [ -z "$string" ] ; then
        fail 'no string'
    fi

    local clean_string=
    clean_string="$(perl -e '$ARGV[0]=~ s/[^a-zA-Z0-9-_]+/ /g; $ARGV[0] =~ s/^\s*|\s*$//g; print lc(substr( $ARGV[0], 0, 50))' "$string")"

    if [ -n "$clean_string" ] ; then
        prn "$clean_string"
    else
        fail "could not clean string '$string'"
        return 1
    fi
}


utils_liburl__urlext_big(){
    local domain="${1:-}"
    if [ -z "$domain" ] ; then
        fail 'no domain'
        return 1
    fi

    local ext=
    case "$domain" in
        *.*) ext="${domain##*.}" ;;
        *) 
            fail "cannot get ext for '$domain'"
            return 1
            ;;
    esac

    if [ -z "$ext" ] ; then
        fail 'no ext'
        return 1
    fi



    case "$ext" in

    utc|aaa|aarp|abb|abbott|abbvie|abc|able|abogado|abudhabi|ac|academy|accenture|accountant|accountants|aco|actor|ad|ads|adult|ae|aeg|aero|aetna|af|afl|africa|ag|agakhan|agency|ai|aig|airbus|airforce|airtel|akdn|al|alibaba|alipay|allfinanz|allstate|ally|alsace|alstom|am|amazon|americanexpress|americanfamily|amex|amfam|amica|amsterdam|analytics|android|anquan|anz|ao|aol|apartments|app|apple|aq|aquarelle|ar|arab|aramco|archi|army|arpa|art|arte|as|asda|asia|associates|at|athleta|attorney|au|auction|audi|audible|audio|auspost|author|auto|autos|aw|aws|ax|axa|az|azure|ba|baby|baidu|banamex|band|bank|bar|barcelona|barclaycard|barclays|barefoot|bargains|baseball|basketball|bauhaus|bayern|bb|bbc|bbt|bbva|bcg|bcn|bd|be|beats|beauty|beer|bentley|berlin|best|bestbuy|bet|bf|bg|bh|bharti|bi|bible|bid|bike|bing|bingo|bio|biz|bj|black|blackfriday|blockbuster|blog|bloomberg|blue|bm|bms|bmw|bn|bnpparibas|bo|boats|boehringer|bofa|bom|bond|boo|book|booking|bosch|bostik|boston|bot|boutique|box|br|bradesco|bridgestone|broadway|broker|brother|brussels|bs|bt|build|builders|business|buy|buzz|bv|bw|by|bz|bzh|ca|cab|cafe|cal|call|calvinklein|cam|camera|camp|canon|capetown|capital|capitalone|car|caravan|cards|care|career|careers|cars|casa|case|cash|casino|cat|catering|catholic|cba|cbn|cbre|cc|cd|center|ceo|cern|cf|cfa|cfd|cg|ch|chanel|channel|charity|chase|chat|cheap|chintai|christmas|chrome|church|ci|cipriani|circle|cisco|citadel|citi|citic|city|ck|cl|claims|cleaning|click|clinic|clinique|clothing|cloud|club|clubmed|cm|cn|co|coach|codes|coffee|college|cologne|com|commbank|community|company|compare|computer|comsec|condos|construction|consulting|contact|contractors|cooking|cool|coop|corsica|country|coupon|coupons|courses|cpa|cr|credit|creditcard|creditunion|cricket|crown|crs|cruise|cruises|cu|cuisinella|cv|cw|cx|cy|cymru|cyou|cz|dabur|dad|dance|data|date|dating|datsun|day|dclk|dds|de|deal|dealer|deals|degree|delivery|dell|deloitte|delta|democrat|dental|dentist|desi|design|dev|dhl|diamonds|diet|digital|direct|directory|discount|discover|dish|diy|dj|dk|dm|dnp|do|docs|doctor|dog|domains|dot|download|drive|dtv|dubai|dunlop|dupont|durban|dvag|dvr|dz|earth|eat|ec|eco|edeka|edu|education|ee|eg|email|emerck|energy|engineer|engineering|enterprises|epson|equipment|er|ericsson|erni|es|esq|estate|et|eu|eurovision|eus|events|exchange|expert|exposed|express|extraspace|fage|fail|fairwinds|faith|family|fan|fans|farm|farmers|fashion|fast|fedex|feedback|ferrari|ferrero|fi|fidelity|fido|film|final|finance|financial|fire|firestone|firmdale|fish|fishing|fit|fitness|fj|fk|flickr|flights|flir|florist|flowers|fly|fm|fo|foo|food|football|ford|forex|forsale|forum|foundation|fox|fr|free|fresenius|frl|frogans|frontier|ftr|fujitsu|fun|fund|furniture|futbol|fyi|ga|gal|gallery|gallo|gallup|game|games|gap|garden|gay|gb|gbiz|gd|gdn|ge|gea|gent|genting|george|gf|gg|ggee|gh|gi|gift|gifts|gives|giving|gl|glass|gle|global|globo|gm|gmail|gmbh|gmo|gmx|gn|godaddy|gold|goldpoint|golf|goo|goodyear|goog|google|gop|got|gov|gp|gq|gr|grainger|graphics|gratis|green|gripe|grocery|group|gs|gt|gu|gucci|guge|guide|guitars|guru|gw|gy|hair|hamburg|hangout|haus|hbo|hdfc|hdfcbank|health|healthcare|help|helsinki|here|hermes|hiphop|hisamitsu|hitachi|hiv|hk|hkt|hm|hn|hockey|holdings|holiday|homedepot|homegoods|homes|homesense|honda|horse|hospital|host|hosting|hot|hotels|hotmail|house|how|hr|hsbc|ht|hu|hughes|hyatt|hyundai|ibm|icbc|ice|icu|id|ie|ieee|ifm|ikano|il|im|imamat|imdb|immo|immobilien|in|inc|industries|infiniti|info|ing|ink|institute|insurance|insure|int|international|intuit|investments|io|ipiranga|iq|ir|irish|is|ismaili|ist|istanbul|it|itau|itv|jaguar|java|jcb|je|jeep|jetzt|jewelry|jio|jll|jm|jmp|jnj|jo|jobs|joburg|jot|joy|jp|jpmorgan|jprs|juegos|juniper|kaufen|kddi|ke|kerryhotels|kerrylogistics|kerryproperties|kfh|kg|kh|ki|kia|kids|kim|kindle|kitchen|kiwi|km|kn|koeln|komatsu|kosher|kp|kpmg|kpn|kr|krd|kred|kuokgroup|kw|ky|kyoto|kz|la|lacaixa|lamborghini|lamer|lancaster|land|landrover|lanxess|lasalle|lat|latino|latrobe|law|lawyer|lb|lc|lds|lease|leclerc|lefrak|legal|lego|lexus|lgbt|li|lidl|life|lifeinsurance|lifestyle|lighting|like|lilly|limited|limo|lincoln|link|lipsy|live|living|lk|llc|llp|loan|loans|locker|locus|lol|london|lotte|lotto|love|lpl|lplfinancial|lr|ls|lt|ltd|ltda|lu|lundbeck|luxe|luxury|lv|ly|ma|madrid|maif|maison|makeup|man|management|mango|map|market|marketing|markets|marriott|marshalls|mattel|mba|mc|mckinsey|md|me|med|media|meet|melbourne|meme|memorial|men|menu|merckmsd|mg|mh|miami|microsoft|mil|mini|mint|mit|mitsubishi|mk|ml|mlb|mls|mm|mma|mn|mo|mobi|mobile|moda|moe|moi|mom|monash|money|monster|mormon|mortgage|moscow|moto|motorcycles|mov|movie|mp|mq|mr|ms|msd|mt|mtn|mtr|mu|museum|music|mv|mw|mx|my|mz|na|nab|nagoya|name|natura|navy|nba|nc|ne|nec|net|netbank|netflix|network|neustar|new|news|next|nextdirect|nexus|nf|nfl|ng|ngo|nhk|ni|nico|nike|nikon|ninja|nissan|nissay|nl|no|nokia|norton|now|nowruz|nowtv|np|nr|nra|nrw|ntt|nu|nyc|nz|obi|observer|office|okinawa|olayan|olayangroup|ollo|om|omega|one|ong|onl|online|ooo|open|oracle|orange|org|organic|origins|osaka|otsuka|ott|ovh|pa|page|panasonic|paris|pars|partners|parts|party|pay|pccw|pe|pet|pf|pfizer|pg|ph|pharmacy|phd|philips|phone|photo|photography|photos|physio|pics|pictet|pictures|pid|pin|ping|pink|pioneer|pizza|pk|pl|place|play|playstation|plumbing|plus|pm|pn|pnc|pohl|poker|politie|porn|post|pr|pramerica|praxi|press|prime|pro|prod|productions|prof|progressive|promo|properties|property|protection|pru|prudential|ps|pt|pub|pw|pwc|py|qa|qpon|quebec|quest|racing|radio|re|read|realestate|realtor|realty|recipes|red|redstone|redumbrella|rehab|reise|reisen|reit|reliance|ren|rent|rentals|repair|report|republican|rest|restaurant|review|reviews|rexroth|rich|richardli|ricoh|ril|rio|rip|ro|rocks|rodeo|rogers|room|rs|rsvp|ru|rugby|ruhr|run|rw|rwe|ryukyu|sa|saarland|safe|safety|sakura|sale|salon|samsclub|samsung|sandvik|sandvikcoromant|sanofi|sap|sarl|sas|save|saxo|sb|sbi|sbs|sc|scb|schaeffler|schmidt|scholarships|school|schule|schwarz|science|scot|sd|se|search|seat|secure|security|seek|select|sener|services|seven|sew|sex|sexy|sfr|sg|sh|shangrila|sharp|shaw|shell|shia|shiksha|shoes|shop|shopping|shouji|show|si|silk|sina|singles|site|sj|sk|ski|skin|sky|skype|sl|sling|sm|smart|smile|sn|sncf|so|soccer|social|softbank|software|sohu|solar|solutions|song|sony|soy|spa|space|sport|spot|sr|srl|ss|st|stada|staples|star|statebank|statefarm|stc|stcgroup|stockholm|storage|store|stream|studio|study|style|su|sucks|supplies|supply|support|surf|surgery|suzuki|sv|swatch|swiss|sx|sy|sydney|systems|sz|tab|taipei|talk|taobao|target|tatamotors|tatar|tattoo|tax|taxi|tc|tci|td|tdk|team|tech|technology|tel|temasek|tennis|teva|tf|tg|th|thd|theater|theatre|tiaa|tickets|tienda|tips|tires|tirol|tj|tjmaxx|tjx|tk|tkmaxx|tl|tm|tmall|tn|to|today|tokyo|tools|top|toray|toshiba|total|tours|town|toyota|toys|tr|trade|trading|training|travel|travelers|travelersinsurance|trust|trv|tt|tube|tui|tunes|tushu|tv|tvs|tw|tz|ua|ubank|ubs|ug|uk|unicom|university|uno|uol|ups|us|uy|uz|va|vacations|vana|vanguard|vc|ve|vegas|ventures|verisign|versicherung|vet|vg|vi|viajes|video|vig|viking|villas|vin|vip|virgin|visa|vision|viva|vivo|vlaanderen|vn|vodka|volvo|vote|voting|voto|voyage|vu|wales|walmart|walter|wang|wanggou|watch|watches|weather|weatherchannel|webcam|weber|website|wed|wedding|weibo|weir|wf|whoswho|wien|wiki|williamhill|win|windows|wine|winners|wme|wolterskluwer|woodside|work|works|world|wow|ws|wtc|wtf|xbox|xerox|xihuan|xin|xxx|xyz|yachts|yahoo|yamaxun|yandex|ye|yodobashi|yoga|yokohama|you|youtube|yt|yun|za|zappos|zara|zero|zip|zm|zone|zuerich|zw)
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}





utils_liburl__filext_big(){
    local file="${1:-}"
    if [ -z "$file" ] ; then
        fail 'no file'
        return 1
    fi

    local ext=
    case "$file" in
        *.*) ext="${file##*.}" ;;
        *) 
            fail 'cannot get ext'
            return 1
            ;;
    esac

    if [ -z "$ext" ] ; then
        fail 'no ext'
        return 1
    fi


    case "$ext" in
        abap|asc|ash|ampl|mod|apib|apl|dyalog|asp|asax|ascx|ashx|asmx|aspx|axd|dats|hats|sats|as|adb|ada|ads|agda|als|apacheconf|vhost|cls|applescript|scpt|arc|ino|asciidoc|adoc|asc|aj|asm|inc|nasm|aug|ahk|ahkl|awk|auk|gawk|mawk|nawk|bat|cmd|befunge|bison|bb|bb|decls|bmx|bsv|boo|b|bf|brs|bro|c|cats|h|idc|w|cs|cake|cshtml|csx|cpp|cc|cp|cxx|h|hh|hpp|hxx|inc|inl|ipp|tcc|tpp|chs|clp|cmake|cob|cbl|ccp|cobol|cpy|css|csv|capnp|mss|ceylon|chpl|ch|ck|cirru|clw|icl|dcl|click|clj|boot|cljc|cljs|cljscm|cljx|hic|coffee|cake|cjsx|cson|iced|cfm|cfml|cfc|lisp|asd|cl|l|lsp|ny|podsl|sexp|cp|cps|cl|coq|v|cppobjdump|creole|cr|feature|cu|cuh|cy|pyx|pxd|pxi|d|di|com|dm|zone|arpa|d|darcspatch|dpatch|dart|diff|patch|dockerfile|djs|dylan|dyl|intr|lid|E|ecl|eclxml|ecl|sch|brd|epj|e|ex|exs|elm|el|emacs|em|emberscript|erl|es|escript|hrl|xrl|yrl|fs|fsi|fsx|fx|flux|f|for|fpp|factor|fy|fancypack|fan|fs|for|fth|f|for|forth|fr|frt|fs|ftl|fr|g|gco|gcode|gms|g|gap|gd|gi|tst|s|ms|gd|glsl|fp|frag|frg|fs|fsh|fshader|geo|geom|glslv|gshader|shader|vert|vrx|vsh|vshader|gml|kid|ebuild|eclass|po|pot|glf|gp|gnu|gnuplot|plot|plt|go|golo|gs|gst|gsx|vark|grace|gradle|gf|gml|graphql|dot|gv|man|1|1in|1m|1x|l|me|ms|n|rno|roff|groovy|grt|gtpl|gvy|gsp|hcl|tf|hlsl|fx|fxh|hlsli|html|htm|inc|st|xht|xhtml|mustache|jinja|eex|erb|phtml|http|hh|php|haml|handlebars|hbs|hb|hs|hsc|hx|hxsl|hy|bf|pro|dlm|ipf|ini|cfg|prefs|pro|properties|irclog|weechatlog|idr|lidr|ni|iss|io|ik|thy|ijs|flex|jflex|json|geojson|lock|topojson|jsonld|jq|jsx|jade|j|java|jsp|js|bones|es|frag|gs|jake|jsb|jscad|jsfl|jsm|jss|njs|pac|sjs|ssjs|xsjs|xsjslib|jl|ipynb|krl|sch|brd|kit|kt|ktm|kts|lfe|ll|lol|lsl|lslp|lvproj|lasso|las|ldml|latte|lean|hlean|less|l|lex|ly|ily|b|m|ld|lds|mod|liquid|lagda|litcoffee|lhs|ls|xm|x|xi|lgt|logtalk|lookml|ls|lua|fcgi|nse|rbxs|wlua|mumps|m|ms|mcr|mtml|muf|m|mak|d|mk|mkfile|mako|mao|md|markdown|mkd|mkdn|mkdown|ron|mask|mathematica|cdf|m|ma|mt|nb|nbp|wl|wlt|matlab|m|maxpat|maxhelp|maxproj|mxt|pat|mediawiki|wiki|m|moo|metal|minid|druby|duby|mir|mirah|mo|mod|mms|mmk|monkey|moo|moon|myt|ncl|nl|nsi|nsh|n|axs|axi|nlogo|nl|lisp|lsp|nginxconf|vhost|nim|nimrod|ninja|nit|nix|nu|numpy|numpyw|numsc|ml|eliom|eliomi|mli|mll|mly|objdump|m|h|mm|j|sj|omgrofl|opa|opal|cl|opencl|p|cls|scad|org|ox|oxh|oxo|oxygene|oz|pwn|inc|php|aw|ctp|fcgi|inc|phps|phpt|pls|pck|pkb|pks|plb|plsql|sql|sql|pov|inc|pan|psc|parrot|pasm|pir|pas|dfm|dpr|inc|lpr|pp|pl|al|cgi|fcgi|perl|ph|plx|pm|pod|psgi|t|nqp|pl|pm|t|pkl|l|pig|pike|pmod|pod|pogo|pony|ps|eps|ps1|psd1|psm1|pde|pl|pro|prolog|yap|spin|proto|asc|pub|pp|pd|pb|pbi|purs|py|bzl|cgi|fcgi|gyp|lmi|pyde|pyp|pyt|pyw|rpy|tac|wsgi|xpy|pytb|qml|qbs|pro|pri|r|rd|rsx|raml|rdoc|rbbas|rbfrm|rbmnu|rbres|rbtbar|rbuistate|rhtml|rmd|rkt|rktd|rktl|scrbl|rl|raw|reb|r|rebol|red|reds|cw|rpy|rs|rsh|robot|rg|rb|builder|fcgi|gemspec|god|irbrc|jbuilder|mspec|pluginspec|podspec|rabl|rake|rbuild|rbw|rbx|ru|ruby|thor|watchr|rs|sas|scss|smt|sparql|rq|sqf|hqf|sql|cql|ddl|inc|prc|tab|udf|viw|sql|ston|svg|sage|sagews|sls|sass|scala|sbt|sc|scaml|scm|sld|sls|sps|ss|sci|sce|tst|self|sh|bash|bats|cgi|command|fcgi|ksh|tmux|tool|zsh|shen|sl|slim|smali|st|cs|tpl|sp|inc|sma|nut|stan|ML|fun|sig|sml|do|ado|doh|ihlp|mata|matah|sthlp|styl|sc|scd|swift|sv|svh|vh|toml|txl|tcl|adp|tm|tcsh|csh|tex|aux|bbx|bib|cbx|cls|dtx|ins|lbx|ltx|mkii|mkiv|mkvi|sty|toc|tea|t|txt|fr|nb|ncl|no|textile|thrift|t|tu|ttl|twig|ts|tsx|upc|anim|asset|mat|meta|prefab|unity|uno|uc|ur|urs|vcl|vhdl|vhd|vhf|vhi|vho|vhs|vht|vhw|vala|vapi|v|veo|vim|vb|bas|cls|frm|frx|vba|vbhtml|vbs|volt|vue|owl|webidl|x10|xc|xml|ant|axml|ccxml|clixml|cproject|csl|csproj|ct|dita|ditamap|ditaval|dotsettings|filters|fsproj|fxml|glade|gml|grxml|iml|ivy|jelly|jsproj|kml|launch|mdpolicy|mm|mod|mxml|nproj|nuspec|odd|osm|plist|pluginspec|props|ps1xml|psc1|pt|rdf|rss|scxml|srdf|storyboard|stTheme|targets|tmCommand|tml|tmLanguage|tmPreferences|tmSnippet|tmTheme|ts|tsx|ui|urdf|ux|vbproj|vcxproj|vssettings|vxml|wsdl|wsf|wxi|wxl|wxs|xacro|xaml|xib|xlf|xliff|xmi|xproj|xsd|xul|zcml|xpl|xproc|xquery|xq|xql|xqm|xqy|xs|xslt|xsl|xtend|yml|reek|rviz|syntax|yaml|yang|y|yacc|yy|zep|zimpl|zmpl|zpl|desktop|ec|eh|edn|fish|mu|nc|ooc|rst|rest|wisp|prg|ch|prw)
        return 0
        ;;
    *)
        return 1
        ;;
esac
}



#utils_liburl__filext_big 'hello.txt' && echo yy
#utils_liburl__urlext_big 'hello.com' && echo yy

#utils_liburl__get_domain 'https://stackoverflow.com/questions/14441521/how-to-truncate-a-string-to-a-specific-length-in-perl'

#utils_liburl__get_web_address 'baba.com'

#title="$(utils_liburl__get_title 'https://stackoverflow.com/questions/14441521/how-to-truncate-a-string-to-a-specific-length-in-perl')"

#utils_liburl__aux_clean_string "$title"
