#
use File::Copy ;
my $headerContent = '';
my $header = '';
my $filename = '';
my $suffix = '';
my $processSub = 1;
my $override = 0;
my $backup = 0;
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
	print "perl adh.pl [option]\n";
print <<EOF;
	Descrption:
	-h The header file path.
	-d The destination of file or folder you wanna process.
	-x Only the given filename suffix will be processed.
	-s if 'true',subdirectories will be processed,otherwise subdirectories will be ignore.
	The default value is true.
	-o if 'true',override the old commit,otherwise ignore the old commit.
	The default value is false.
	--no-sub The same as -s false.
	--override The same as -o true.
	--backup backup the processed file with suffix 'bak'.
EOF
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
		if (!$override) {
			print "file $fileNow seem already have header,ignore it .\n";		
			return;
		} else {#覆盖原来的注释
			shift @content;
			while (scalar(@content) > 0) {
				if ($content[0] !~ /^[^\/]*\*\//) {		
					
					shift @content;
				} else {
					
					shift @content;
					last;
				}
			}
		}		
	}
	my $contentStr =  join "", @content;
	#print $contentStr."\n";
	$file = open NEW, ">$fileNow";
	if (!$file) {
		print "can't open $fileNow for write.\n";
		return;
	}
	if ($backup) {
		copy($file,$file.'.bak');
	}
	print NEW "/**\r\n";
	print NEW $headerContent;
	print NEW "\r\n*/\r\n";
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
			 if ($processSub) {#处理子目录
				 operateFolder($pathNow,$suffix) if($fd !~ /^(\.|\.\.)$/);
			 }			  
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
#参数解析
sub parseParam {
	my @params = @{$_[0]};
	my $i = 0;
	while ($i < @params ) {
		my $param = $params[$i];
		#print $param."\n";
		if ($param eq '-h') {
			$header = $params[++$i];
			print $header."\n";
		} elsif ($param eq '-d') {
			$filename = $params[++$i];
		} elsif ($param eq '-x') {
			$suffix = $params[++$i];
		} elsif ($param eq '-s') {
			if ($params[++$i] eq 'false') {
				$processSub = 0;
			}
		} elsif ($param eq '-o') {
			if ($params[++$i] eq 'true') {
				$override = 1;
			}
		} elsif ($param eq '--no-sub') {
			$processSub = 0;
		} elsif ($param eq '--override') {
			$override = 1;
		} elsif ($param eq '--backup') {
			$backup = 1;
		}
		$i++;
	}

	if (not -e $header) {
		die("you given header file is not exist.\n");
		return 0;
	}
	getHeaderContent($header);
	if (not -e $filename) {
		die('the folder or file you given is not exist\n');
		return 0;
	}
	if(checkIfFolder($filename)) {
		operateFolder($filename,$suffix);
	} else {
		operateFile($filename,$suffix);
	}	
	return 1;
}
#入口处理
if (@ARGV == 1) {
	if ($ARGV[0] eq '--help') {
	} else {
		print "not enough paramater.\n";
	}	
	showHelp();
} elsif (parseParam(\@ARGV)) {
	print "operate over.\n";	
} else {
	print "invalid paramaters.\n";
	showHelp();
}
