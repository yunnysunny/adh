my $headerContent = '';
sub checkIfFolder {
  my $name=$_[0];
   
  if( opendir DH,$name){
     closedir DH;
     return 1;
  }
  return 0;  
}
sub showHelp() {
	print "=======Add doc Header==========\n";
	print "=copyright yunnysunny<yunnysunny\@gmail.com>=\n";
	print "perl adh.pl [header file path] [the folder or file to be operated]([the file suffix to be selected])\n";
	print "for example:\n";
	print "perl adh.pl copyright.txt . java\n";
	print "this command will add the header to all the java files in current folder.\n";
	print "notice:it will also operate the sub folders in this version.\n";
}
sub addHeader {
	my $fileNow = $_[0];
	my $file = open FILE,$fileNow;
	if (!$file) {
		print "open file $fileNow failed.\n";
		return;
	}
	my @content = <FILE>;
	close FILE;
	if ($content[0] =~ /^\/\*\*/) {
		print "file $fileNow seem already have header,ignore it .\n";
		return;
	}
	my $contentStr =  join "", @content;
	$file = open NEW, ">$fileNow";
	if (!$file) {
		print "can't open $fileNow for write.\n";
		return;
	}
	print NEW "/**\n";
	print NEW $headerContent;
	print NEW "\n*/\n";
	print NEW $contentStr;
	close NEW;
}
sub operateFile {
	my $filename = $_[0];
	my $suffix = $_[1];
	
	#print "operate $filename now\n";
	if ($suffix) {
		if ($filename =~ /\.\Q$suffix\E$/) {
			addHeader($filename);
		} else {
			print "ignore $filename for not matching suffix $suffix\n";
		}
	} else {
		addHeader($filename);
	}
}
sub operateFolder {
	my $baseName = $_[0];
	my $suffix = $_[1];

	opendir DH,$baseName or die "Can't Open $baseName,Information:$!!\n"; 
	my @dirs=readdir DH;
	 foreach my$fd(@dirs) {
		 my $pathNow = $baseName."\\".$fd;
		 if(checkIfFolder($pathNow)) {
			  operateFolder($pathNow,$suffix) if($fd !~ /^(\.|\.\.)$/);
		 } else {
			 operateFile($pathNow,$suffix);
		 }
	 }

}
sub getHeaderContent {
	my $headerPath = $_[0];
	open HEAD,$headerPath or die("cant't open $headerPath\n");
	my @lines = <HEAD>;

	$headerContent = join "", @lines;
}
if (@ARGV < 2) {
	print "not enough paramater.\n";
	showHelp();
} elsif (@ARGV == 2 || @ARGV == 3) {
	my $header = $ARGV[0];
	my $filename = $ARGV[1];
	my $suffix = $ARGV[2];
	if (not -e $header) {
		die("you given header file is not exist.\n");
	}
	getHeaderContent($header);
	if (not -e $filename) {
		die('the folder or file you given is not exist\n');
	}
	if(checkIfFolder($filename)) {
		operateFolder($filename,$suffix);
	} else {
		operateFile($filename,$suffix);
	}	
} else {
	print "too many paramater.\n";
	showHelp();
}
