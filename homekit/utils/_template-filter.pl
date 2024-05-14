use strict;
use warnings;

my ($filename, @words) = @ARGV;

die 'usage: <filename> args ...' unless $filename;


my $regex_alpha = '[a-zA-Z0-Z_]+'; 
my $regex_post = '\s*\(\s*\)\s*\{\s*';

my $func_regex = qr/^\s*${regex_alpha}__${regex_alpha}${regex_post}/;

open (my $fh, '<', $filename) || die "Err: could not open $filename";

my ($modulino_regex, @regexes);
my $word;
for  (@words){
    $word = $_;
    push @regexes, qr/^\s*${regex_alpha}__${word}${regex_post}/; 
    $modulino_regex = qr/^\s*####\s+Modulino\s*/  if($word eq 'main');
}


my $regex = shift @regexes if @regexes;
my $switch = 1; 

my $caller_regex = qr/^\s*(${regex_alpha}__${word})${regex_post}/;


my $caller_line;
sub looper {
    foreach(<$fh>){
        chomp;

        if(/$caller_regex/){ $caller_line = $1 }

        if($switch){
            if(/$func_regex/){

                undef $switch;
                if( (defined $regex) && ($_ =~  /$regex/)){
                    if(@regexes){
                        $regex = shift @regexes ;
                    }else{
                        undef $regex;
                    }
                    $switch = 1;
                }
            }elsif((defined $modulino_regex ) && ($_ =~ /$modulino_regex/)){
                print "}\n";
                print $caller_line . ' "$@"' . "\n";
                undef $switch ;
            }
        }else{
            if((defined $regex) && ($_ =~ /$regex/)){
                if(@regexes){
                    $regex = shift @regexes ;
                }else{
                    undef $regex;
                }
                $switch = 1;
            }
        }

        print $_ . "\n" if $switch;
    }
    print $caller_line . ' "$@"';
}

if(@words){
    looper
}else{
    foreach(<$fh>){
        print $_
    }
}



