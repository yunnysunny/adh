## Add docment header ##

**使用方法：**  
`perl adh.pl [选项] `  
选项说明：  
	-h 指定头部文件的路径.  
	-d 指定要操作的目标文件或者目标文件夹.  
	-x 指定需要处理的文件后缀，不是指定的文件后缀将会被忽略.  
	-s 如果设定为true，则会处理子目录，否则将忽略子目录，默认为true。       
	-o 如果为true，则会将之前存在的文件头部覆盖掉，否则将忽略已经存在文件头部的文件，默认为false。  
	--no-sub 和-s false的作用相同.  
	--override 和 -o true的作用相同.  
	--backup 备份要处理的文件，以.bak为后缀.    
示例：  
> perl adh.pl -h aa.txt -d . -x java -o true --no-sub  
这行命令就将当前目录下的所有java文件添加copyright.txt文件内容作为注释的头部内容，如果之前存在头部文件，将会用copyright的内容覆盖掉，同时此项操作不会处理子目录。     
**注意：**  
当前版本暂只支持/**开头的注释头部。  



