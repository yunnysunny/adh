## Add docment header ##

**使用方法：**  
`perl adh.pl [头部文件路径] [要操作的文件夹或者文件]([过滤选中的文件后缀])`  
示例：  
> perl adh.pl copyright.txt . java  
这行命令就将当前目录下的所有java文件添加copyright.txt文件内容作为注释的头部内容   
**注意：**  
当前版本暂支持递归处理所有子目录下的文件，所以上述命令将当前目录和当前目录的子目录的所有java文件进行处理。  



