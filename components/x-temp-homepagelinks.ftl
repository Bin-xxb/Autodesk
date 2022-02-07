<#assign catId=http.request.parameters.name.get("catId", "") />
<#assign catId="8"/>
<#assign 
            additional_forums = settings.name.get("autodesk.additional_forums")	
            full_list =[] 
            valid_cats = []
            additional_forums_idsArray=[]
            />
            <#assign tempObj={}/>
            <#assign additional_forums_idsArray=additional_forums?split(',')/>
            <#assign additional_forums_cnt = additional_forums_idsArray?size />	
            <#assign full_list_array=[]/>

            <#assign full_list = usercache.get("additionals_key1", "") />
            <#if full_list?is_string>
                <#assign full_list=[]/>
            </#if>
          
            <#if !(full_list?has_content)>
                <#if  additional_forums_cnt gt  0>
                    <#-- check if id is category or board and forming a array of category nodes only-->

                    <#assign additional_forums_only_cats_array_filtered=[]/>
                    <#assign allCategoryNodesArray=[]/>
                    <#assign allCategoryNodes=rest('/nodes/type/key/category/nested?restapi.response_style=view&page_size=1000') />
                    <#list allCategoryNodes.nodes.node as node>
                        <#assign allCategoryNodesArray=allCategoryNodesArray+[node.id] /> 
                    </#list>

                    <#list additional_forums_idsArray as in_forum_cat >
                        <#if allCategoryNodesArray?seq_contains(in_forum_cat)>
                            <#assign additional_forums_only_cats_array_filtered=additional_forums_only_cats_array_filtered+[in_forum_cat]/>
                        </#if>
                    </#list>
                    <#assign additional_forums_cats_array=[]/>  
                    <#assign additional_forums_cats=""/>
                    <#list additional_forums_only_cats_array_filtered as cat_id>
                            <#if rest("/categories/id/${cat_id}/view/allowed").value == "true" && restadmin('/categories/id/${cat_id}/settings/name/config.hidden').value=="false"> 
                                <#if restadmin("/categories/id/${cat_id}/settings/name/config.read_only").value == "false">
                                    <#assign boardsCount =rest("/categories/id/${cat_id}/boards/style/forum/count").value?number/>
                                    <#if boardsCount gt 0>
                                        <#assign categoryResponse =rest("/categories/id/${cat_id}").category/>
                                        <#assign valid_cats=valid_cats+[{"id" : "${categoryResponse.id}","title" : "${categoryResponse.title}"}]/>
                                      	${categoryResponse.title}
                                    </#if>
                                </#if>               
                        </#if>	
                    </#list>
                    <#assign full_list = valid_cats/>
                   </#if>
                <#assign full_list1 = usercache.put("additionals_key1", full_list) />
            </#if>
            <#list full_list as l>
                <#assign full_list_array=full_list_array+[l.id]/>
            </#list>  
            <#-- add catID from url to drop down create catId object start -->
                <#if catId!=""  && additional_forums_idsArray?seq_contains(catId) && !(full_list_array?seq_contains(catId))>
                    <#assign categoryResponse =rest("/categories/id/${catId}").category/>
                    <#assign tempObj=tempObj+{"id" : "${categoryResponse.id}","title" : "${categoryResponse.title}"}/>
                    <#assign full_list=full_list+[tempObj]/>
                </#if>
            <#-- add catID from url to drop down create catId object end --> 
            <#-- here is sorting of final list -->	
                <#assign full_list=full_list?sort_by("title")/>
            <#-- here is sorting of final list -->	
          ${full_list?size}
          <#list full_list as f>
            	${f.title}<br>
           </#list>
          
          
			