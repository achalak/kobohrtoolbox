select_all_score2zo <- function(data1, agg_method1) {
  print(paste0("Recode select all values to 1/0"))
  ### First we provide attribute label to variable name
  #data.label <- as.data.frame(names(data))
  #data<-as.data.frame(data,stringsAsFactors=FALSE,check.names=FALSE)
  data_names<-names(data1)
  #-select all the field headers for select one
  agg_m_sall<-filter(agg_method1,aggmethod=="SEL_ALL")
  #--loop through all the rows or take all value
  agg_m_sall_headers<-distinct(as.data.frame(agg_m_sall[,"gname"]))
  data_rec<-as.data.frame(data1) # dont see any reason to do it
  
  for(i in 1:nrow(agg_m_sall_headers)){
    i_headername<-agg_m_sall_headers[i,1]
    #column index from the data
    col_ind<-which(str_detect(data_names, paste0(i_headername,"/")) %in% TRUE)
    #Replace only if header is found in the main data table
    if (length(col_ind)>0){
        #loop through each index
        for (i_lt in col_ind){
          #i_lt=2
          d_i_lt<-conv_num(data_rec[,i_lt])
          data_rec[,i_lt]<-ifelse(d_i_lt>1,1,data_rec[,i_lt])
        }
    }
  }#finish recoding of select one ORDINAL
  return(data_rec)
}
NULL

select_upto_n_score2zo <- function(data1, agg_method1) {
  print(paste0("Recode select all values to 1/0"))
  ### First we provide attribute label to variable name
  #data.label <- as.data.frame(names(data))
  #data<-as.data.frame(data,stringsAsFactors=FALSE,check.names=FALSE)
  data_names<-names(data1)
  #-select all the field headers for select one
  agg_m3<-filter(agg_method1,aggmethod=="SEL_3" | aggmethod=="SEL_4")
  #--loop through all the rows or take all value
  agg_m3_headers<-distinct(as.data.frame(agg_m3[,c("gname","aggmethod")]))
  data_rec<-as.data.frame(data1) # dont see any reason to do it
  
  for(i in 1:nrow(agg_m3_headers)){
    i_headername<-agg_m3_headers[i,1]
    i_type<-agg_m3_headers[i,2]
    #column index from the data
    col_ind<-which(str_detect(data_names, paste0(i_headername,"/")) %in% TRUE)
    #Replace only if header is found in the main data table
    if (length(col_ind)>0){
      #loop through each index
      list_rnk<-data_rec[,col_ind]
      for (i_list in 1:ncol(list_rnk)){
        list_rnk[,i_list]<-as.numeric(as.character(list_rnk[,i_list]))
      }
     
      rank3<-t(apply(list_rnk,1,function(x) rank(-x,na.last="keep", ties.method = "min")))
      #Zero removed - ZERO in the main table is substituted with maximum rank value
      for(ir in 1:ncol(rank3)){
        rank3[,ir]<-ifelse(list_rnk[,ir]==0,ncol(rank3),rank3[,ir])
      }
      #Now select based on SEL_3 or SEL_4
      
      if(i_type=="SEL_4"){
        for(ir in 1:ncol(rank3)){rank3[,ir]<- rank3[,ir]<=4}
      }else{
        for(ir in 1:ncol(rank3)){rank3[,ir]<- rank3[,ir]<=3}
      }
      #Replace values in the main table
      data_rec[,col_ind]<-rank3
      
      # count<-0
      # for (i_lt in col_ind){
      #   count<-count+1
      #   data_rec[,i_lt]<-rank3[,count]
      # }
    }
  }#finish recoding of select one ORDINAL
  return(data_rec)
}
NULL


select_rank_score2rank <- function(data1, agg_method1) {
  print(paste0("Recode select all values to 1/0"))
  ### First we provide attribute label to variable name
  #data.label <- as.data.frame(names(data))
  #data<-as.data.frame(data,stringsAsFactors=FALSE,check.names=FALSE)
  data_names<-names(data1)
  #-select all the field headers for select one
  agg_m3<-filter(agg_method1,aggmethod=="SEL_3" | aggmethod=="SEL_4")
  #--loop through all the rows or take all value
  agg_m3_headers<-distinct(as.data.frame(agg_m3[,c("gname","aggmethod")]))
  data_rec<-as.data.frame(data1) # dont see any reason to do it
  
  for(i in 1:nrow(agg_m3_headers)){
    i_headername<-agg_m3_headers[i,1]
    i_type<-agg_m3_headers[i,2]
    #column index from the data
    col_ind<-which(str_detect(data_names, paste0(i_headername,"/")) %in% TRUE)
    #Replace only if header is found in the main data table
    if (length(col_ind)>0){
      #loop through each index
      list_rnk<-data_rec[,col_ind]
      for (i_list in 1:ncol(list_rnk)){
        list_rnk[,i_list]<-as.numeric(as.character(list_rnk[,i_list]))
      }
      
      rank3<-t(apply(list_rnk,1,function(x) rank(-x,na.last="keep", ties.method = "min")))
      #Zero removed - ZERO in the main table is substituted with maximum rank value
      for(ir in 1:ncol(rank3)){
        rank3[,ir]<-ifelse(list_rnk[,ir]==0,ncol(rank3),rank3[,ir])
      }
      #Now select based on SEL_3 or SEL_4
      
      if(i_type=="SEL_4"){
        for(ir in 1:ncol(rank3)){rank3[,ir]<- rank3[,ir]<=4}
      }else{
        for(ir in 1:ncol(rank3)){rank3[,ir]<- rank3[,ir]<=3}
      }
      #Replace values in the main table
      data_rec[,col_ind]<-rank3
      
      # count<-0
      # for (i_lt in col_ind){
      #   count<-count+1
      #   data_rec[,i_lt]<-rank3[,count]
      # }
    }
  }#finish recoding of select one ORDINAL
  return(data_rec)
}
NULL


