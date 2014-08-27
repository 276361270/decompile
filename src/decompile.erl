-module(decompile).

-compile([export_all]).
%--------------------------------------------------------------------
%% @doc 反编译导出编译文件
%% @spec FilePath 要翻译文件的存放文件夹 OutFilePath 反编译出来的文件的erl 存放文件夹
%% @spec decompile:export_all("/home/thinkpad/ebin","/home/thinkpad/src"). 使用例子
%% @end
%%--------------------------------------------------------------------

export_all(FilePath,OutFilePath)->
	{ok,FileList} = file:list_dir(FilePath),
	lists:foreach(
		fun (FileName) -> 
			Length = string:len(FileName),
			NewFileName = string:sub_string(FileName, 1, Length-4),  
			io:format(" export file name ~p~n", [FileName]), 
			{ok, {_, [{abstract_code, {_,Abs}}]}} = beam_lib:chunks(FilePath++"/"++FileName, [abstract_code]),
			{ok,IoDevice} = file:open(OutFilePath++"/"++NewFileName++"erl", [write]),
			io:fwrite(IoDevice, "~s~n", [erl_prettypr:format(erl_syntax:form_list(Abs) ) ]), 
			file:close(IoDevice)
			end,
	  FileList). 

export(BeamFile)->
	{ok, {_, [{abstract_code, {_,Abs}}]}} =  beam_lib:chunks(BeamFile, [abstract_code]),io:fwrite("~s~n", [erl_prettypr:format(erl_syntax:form_list(Abs))]).
