BEGIN{ $switch = 1; };
$switch = undef if /^[a-z]+__init\s*\(\s*\)\s*\{\s*$/ ;
$switch = 1 if s/^[a-z]+__main\s*\(\s*\)\s*\{\s*$/main(){\n/g ;
$switch = undef if /^\s*########*\s*Bkblib\s*$/ ;
print "$_" if $switch; 
END{ print "main\n"; };
