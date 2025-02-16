			
		@AuraEnable
		public static string getRatingDetails(){  
			
			ID Companyfin =Schema.SObjectType.Document_Statement__c.getRecordTypeInfosByName().get('Company Financials').getRecordTypeId();
			ID customerfin =Schema.SObjectType.Document_Statement__c.getRecordTypeInfosByName().get('Customer Financials').getRecordTypeId();        
        
			Leadid=ApexPages.currentPage().getParameters().get('Id');
			Lead l = [Select ID,Broker_Name__r.Name,RLS_Category__c,Quality_Check_Status__c from lead where id=:Leadid];
			system.debug('l.category --- '+l.RLS_Category__c);
			if(l.RLS_Category__c == 'ABL Without Receivables' || l.RLS_Category__c == 'ABL With Receivables'){
				type = 'ABL';
				system.debug('type --- '+type);
			}else{
				type = l.RLS_Category__c;
			}
			
			for(Master_AUW_Criteria__mdt mauw :[select id,End_Date_for_Accounts__c,Bankruptcy_Order__c,Insolvency__c,Average_Balance_Trend__c,Turnover_Trend__c,Transaction_Trend__c,Bounces_last_3_months__c,Loan_Repayments_of_TO__c,Turnover__c,Tangible_Net_Worth__c,Share_Capital__c,Share_Premium__c,Salary_Wages__c,Director_Salary__c,Incorporation_Date_mnths__c,Last_Filed_Account_End_Date_Mnths__c,                   Bank_Stmt_Start_Date__c,Bank_Stmt_End_Date__c,Overdraft_Limit_Amount__c,Profit_Loss__c, Band_Score__c from Master_AUW_Criteria__mdt where Product_Name__c = 'RLS' and Product_Category__c=:type])//and Product_Category__c=:type
			{
				EndDateAcc = mauw.End_Date_for_Accounts__c;
				Turnover = mauw.Turnover__c;
				TNW = mauw.Tangible_Net_Worth__c;
				ProfitLoss = mauw.Profit_Loss__c;
				SharePremium = mauw.Share_Premium__c;
				ShareCapital = mauw.Share_Capital__c;
				SalaryWages = mauw.Salary_Wages__c;
				DirectorSalary = mauw.Director_Salary__c;
				IncorporationDate =mauw.Incorporation_Date_mnths__c;
				LastFiledAccDate = mauw.Last_Filed_Account_End_Date_Mnths__c;
				AVGBalenceTrend = mauw.Average_Balance_Trend__c;
				TurnOverTrend = mauw.Turnover_Trend__c;
				TransactionTrend = mauw.Transaction_Trend__c;
				BouncesIn3Mnths = mauw.Bounces_last_3_months__c;
				LoanRepaymentofTO = mauw.Loan_Repayments_of_TO__c;
				BankStmtStartDate = mauw.Bank_Stmt_Start_Date__c;
				BankStmtEndDate = mauw.Bank_Stmt_End_Date__c;
				Overdraft = mauw.Overdraft_Limit_Amount__c;
				BandScore = mauw.Band_Score__c;
				Insolvency = mauw.Insolvency__c.split(',');
				Bankruptcy = mauw.Bankruptcy_Order__c.split(',');
			}
        
				system.debug('EndDateAcc --- '+EndDateAcc);
				system.debug('Turnover --- '+Turnover);
				system.debug('IncorporationDate --- '+IncorporationDate);
				system.debug('LastFiledAccDate --- '+LastFiledAccDate);
		
		
        listDoc = [SELECT Id,Lead_Name__r.Incorporation_Date__c,Nucleus_Band_Rating__c,Lead_Name__r.Quality_Check_Status__c,Lead_Name__r.Id,Forecast_Account_Check__c,Lead_Name__r.X12_Month_Forecasts__c,P1_Mandatory_Check__c,Last_Account_Period_End_on__c,Incorporation_Date__c,isRequiredFields__c,CW_Turnover_P0__c,Lead_Name__r.Amount_Requested__c,Full_Accounts_End_Date__c,Lead_name__r.Product_of_interest2__r.Name,CW_Turnover_P1__c,CW_Tangible_NW_P1__c,Master_Customer_Financials__c,Use_this_for_DD__c,CW_Profit_Lost_P1__c,CW_Profit_Lost_P0__c,CW_Tangible_NW_P0__c,Share_Capital_P1__c,Share_Capital_P0__c,Wages_Salaries__c,Director_s_Salary__c,Full_Accounts_End_Date_So__c,Share_Premium_P1__c,Share_Premium_P0__c,CW_Date_Period_1__c,Audited_Accounts_Check__c,End_Date_P0__c,End_Date_P_1__c,Draft_Account_Check__c,End_Date_P_2__c,Management_Account_Check__c,Lead_Name__r.Management_Accounts__c,Lead_Name__r.Full_Audited_Accounts__c,Lead_Name__r.Draft_Accounts__c FROM Document_Statement__c WHERE Lead_Name__r.Id = : Leadid  AND RecordTypeID =: Companyfin];
		system.debug('listDoc------'+listDoc);
		
        List<Document_Statement__c> listDocCustomer = [SELECT Id,Lead_Name__r.Id,Lead_Name__r.RLS_Category__c,Master_Customer_Financials__c,Transactions_3_Mnths__c,EndDate__c,Startdate__c,Bounces_last_3_months__c,AVG_Balance_3_Mnths__c,                                                       Average_Balance_Trend__c,Loan_Repayments_as_of_T_O_3_Mnths__c,Correct_Overdraft__c,Overdraft_Limit_Amount__c,Alternative_Loans_in_last_3_months__c,Transaction_Trend_3M_12M__c,Turnover_Trend_3M_12M__c FROM Document_Statement__c WHERE Lead_Name__r.Id = : Leadid  AND RecordTypeID =: customerfin AND Master_Customer_Financials__c = True LIMIT 1];
		system.debug('Customer Financial List Master Financials------'+listDocCustomer.size());  
        
        listDocUpdateUseDD = [SELECT Id,TL_Created__c ,Lead_Name__r.Id,Lead_Name__r.Quality_Check_Status__c,Lead_Name__r.Bank_Statement_3_months__c,Lead_Name__r.isSignup__c,Lead_Name__r.OB_Consent__c,EndDate__c,Startdate__c,AVG_Balance_3_Mnths__c,Use_this_for_DD__c,Master_Customer_Financials__c,CountTL__c,No_of_M3_Transactions__c,CountTC__c,Account_Number__c,Correct_Overdraft__c,Branch_Sort_Code__c,Lead_Name__r.Company,Name_of_Acc_Holder__c,Acct_holder_name_mismatched__c,Overdraft_Limit_Amount__c FROM Document_Statement__c WHERE Lead_Name__r.Id = : Leadid  AND RecordTypeID =: customerfin AND Use_this_for_DD__c = True AND Acct_holder_name_mismatched__c = False AND TL_Created__c = TRUE   AND Name_of_Acc_Holder__c <> NULL AND Account_Number__c <> NULL AND Branch_Sort_Code__c <> NULL];
        system.debug('Customer Financial List Use This for DD------'+listDocUpdateUseDD); 
		
		
        listDocUpdateBank = [SELECT Id,TL_Created__c,Lead_Name__r.Id,Lead_Name__r.Quality_Check_Status__c,Lead_Name__r.Bank_Statement_3_months__c,Lead_Name__r.isSignup__c,Lead_Name__r.OB_Consent__c,EndDate__c,Startdate__c,AVG_Balance_3_Mnths__c,Use_this_for_DD__c,Master_Customer_Financials__c,CountTL__c,No_of_M3_Transactions__c,CountTC__c,Account_Number__c,Correct_Overdraft__c,Branch_Sort_Code__c,Lead_Name__r.Company,Name_of_Acc_Holder__c,Acct_holder_name_mismatched__c,Overdraft_Limit_Amount__c FROM Document_Statement__c WHERE Lead_Name__r.Id = : Leadid  AND RecordTypeID =: customerfin AND TL_Created__c = TRUE ];
        system.debug('Customer Financial List Bank------'+listDocUpdateBank);

		
        cont = [select Id,Insolvency_Detected__c,Delphi_Score__c,Band_Score__c,Bankruptcy_Restriction_Order__c,ID_Confirmed_Level_Info__c,AML_Decision_Info__c,ContLead__r.Product_of_interest2__r.Name,Product_Name__c,ContLead__c,Phone,MobilePhone,Experian_Reference__c,Birthdate,Residential_House_Name__c,Residential_House_Number__c,Risk_Status__c,Email, Residential_Address_Zip_Postal_Code__c,Residential_Address_Street__c,SignatoryDirector__c from Contact where ContLead__c = : Leadid  AND Experian_Reference__c <> NULL AND Birthdate != NULL AND SignatoryDirector__c = TRUE AND Band_Score__c >=: BandScore   AND (Residential_House_Name__c != NULL OR Residential_House_Number__c != NULL) AND Residential_Address_Zip_Postal_Code__c != NULL AND Residential_Address_Street__c != NULL AND (Risk_Status__c = 'Low' OR Risk_Status__c = 'Very Low') AND (Phone <> NULL OR MobilePhone <> NULL) AND Email<> NULL];
        system.debug('Con List :'+cont);
		
		
        TotalConList =  [select Id,Band_Score__c,Bankruptcy_Restriction_Order__c,Insolvency_Detected__c,ContLead__r.Product_of_interest2__r.Name,Product_Name__c,ContLead__c,Phone,MobilePhone,Experian_Reference__c,Birthdate,Residential_House_Name__c,Residential_House_Number__c,Risk_Status__c,Email,Residential_Address_Zip_Postal_Code__c,Residential_Address_Street__c,SignatoryDirector__c from Contact where ContLead__c =: Leadid  AND Experian_Reference__c = NULL AND Birthdate != NULL AND SignatoryDirector__c = TRUE   AND (Residential_House_Name__c != NULL OR Residential_House_Number__c != NULL) AND Residential_Address_Zip_Postal_Code__c != NULL AND Residential_Address_Street__c != NULL AND (Risk_Status__c = 'Low' OR Risk_Status__c = 'Very Low') AND (Phone <> NULL OR MobilePhone <> NULL) AND Email<> NULL];
	    system.debug('Total Con List :'+TotalconList.size());
		
		
        SignatoryList = [select Id,Band_Score__c,PG__c,ContLead__r.Product_of_interest2__r.Name,Product_Name__c,ContLead__c,Phone,MobilePhone,Experian_Reference__c,Birthdate,Residential_House_Name__c,Residential_House_Number__c,Risk_Status__c,Email,Residential_Address_Zip_Postal_Code__c,Residential_Address_Street__c,SignatoryDirector__c from Contact where ContLead__c = : Leadid  AND Birthdate != NULL AND SignatoryDirector__c = TRUE AND (Residential_House_Name__c != NULL OR Residential_House_Number__c != NULL) AND Residential_Address_Zip_Postal_Code__c != NULL AND Residential_Address_Street__c != NULL AND (Phone <> NULL OR MobilePhone <> NULL) AND Email<> NULL];						 
						 
						 
        PGList = [select Id,Band_Score__c,PG__c,ContLead__r.Product_of_interest2__r.Name,Product_Name__c,ContLead__c,Phone,MobilePhone,Experian_Reference__c,Birthdate,Residential_House_Name__c,Residential_House_Number__c,Risk_Status__c,Email,Residential_Address_Zip_Postal_Code__c,Residential_Address_Street__c,SignatoryDirector__c from Contact where ContLead__c = : Leadid and pg__c= true ];
				  
				  
        AdddirList = [select Id,Band_Score__c,PG__c,ContLead__r.Product_of_interest2__r.Name,Product_Name__c,Quality_Review_Status__c,ContLead__c,Phone,MobilePhone,Experian_Reference__c,Birthdate,Residential_House_Name__c,Residential_House_Number__c,Risk_Status__c,Email, Residential_Address_Zip_Postal_Code__c,Residential_Address_Street__c,SignatoryDirector__c from Contact where ContLead__c = : Leadid and Quality_Review_Status__c != NULL ];
				  
				  
        boolean PG= false;
		String AMLDEC='The Applicant has been Authenticated to your required \'Level 1\'';
		String IDCONFAML='The identity supplied has been confirmed at the required \'Level 1\'';
		Integer AMLCheck=0;
		
        for(contact c:PGList){
            if(c.pg__c){
                PG=true;
            }
        }
        if(AdddirList.size()  == 0) AdddirCheck='Green';
		
		
        for(contact c:AdddirList){
				if(c.Quality_Review_Status__c == 'Review Pending'){
					AdddirCheck='Yellow';
				}else{
					AdddirCheck='Green'; 
				}
        }
		for(contact c:cont){
			if(c.ID_Confirmed_Level_Info__c== IDCONFAML && c.AML_Decision_Info__c ==AMLDEC && c.Band_Score__c >=3 && c.Delphi_Score__c >0 &&( c.Bankruptcy_Restriction_Order__c != '' &&c.Bankruptcy_Restriction_Order__c != 'Y' && c.Bankruptcy_Restriction_Order__c != null && c.Bankruptcy_Restriction_Order__c != 'T')&& (c.Insolvency_Detected__c !='Y' && c.Insolvency_Detected__c !='' && c.Insolvency_Detected__c !=null && c.Insolvency_Detected__c !='T' ) ){
				AMLCheck++;
			} 
		}
        system.debug('Con List :'+cont);
		
		if(cont.size() > 0 && AMLCheck >=1 && l.RLS_Category__c.touppercase() =='UNSECURED' ){
				ExperianCheck = 'Green';
				system.debug('Green -- '+ExperianCheck);
		}else if(cont.size() > 0 && AMLCheck >=2 && (l.RLS_Category__c.touppercase() =='SECURED' || l.RLS_Category__c.contains('ABL'))){
				ExperianCheck = 'Green';
		}else{
		ExperianCheck = 'Yellow';
		}
		
		
        if(SignatoryList.size() > 0 && l.RLS_Category__c.touppercase() =='UNSECURED'){
            SignCheck = 'Green';
        }else if(SignatoryList.size() <= 0 && l.RLS_Category__c.touppercase() =='UNSECURED'){
            SignCheck = 'Yellow';
        }if(SignatoryList.size() > 1  && PG && (l.RLS_Category__c.touppercase() =='SECURED' || l.RLS_Category__c.contains('ABL'))){
            SignCheck = 'Green';
            
        }else if(SignatoryList.size() <= 1  && PG && (l.RLS_Category__c.touppercase() =='SECURED' || l.RLS_Category__c.contains('ABL'))){
            SignCheck = 'Yellow';
        }
        if(listDocUpdateBank.size() > 0){
            for(Document_Statement__c docdd : listDocUpdateBank){
                system.debug('3 mnts bank statement --- '+docdd.Lead_Name__r.Bank_Statement_3_months__c);
                system.debug('OB Consent --- '+docdd.Lead_Name__r.OB_Consent__c);
                system.debug('OB sign --- '+docdd.Lead_Name__r.isSignup__c);
                if((docdd.Lead_Name__r.Bank_Statement_3_months__c && docdd.Lead_Name__r.OB_Consent__c == False) || (docdd.Lead_Name__r.isSignup__c && docdd.Lead_Name__r.OB_Consent__c))
                {
                    Bank = 'Green';
                    system.debug('Bank Status --- '+Bank);
                }
            }
        }
		if( listDocUpdateUseDD.size() > 0){
			CustFinDD = 'Green';          
		}else{
			CustFinDD = 'Yellow';
		}
        
        if(listDocCustomer.size() > 0)
        {
            for(Document_Statement__c doccus : listDocCustomer)
            {
                system.debug('doccus.EndDate__c:'+doccus.EndDate__c+ 'doccus.Startdate__c:'+doccus.Startdate__c);
                system.debug('doccus.Bounces_last_3_months__c:'+doccus.Bounces_last_3_months__c+ 'doccus.Average_Balance_Trend__c:'+doccus.Average_Balance_Trend__c);
                system.debug('doccus.Loan_Repayments_as_of_T_O_3_Mnths__c:'+doccus.Loan_Repayments_as_of_T_O_3_Mnths__c+ 'doccus.Transaction_Trend_3M_12M__c:'+doccus.Transaction_Trend_3M_12M__c);
                system.debug('doccus.Turnover_Trend_3M_12M__c:'+doccus.Turnover_Trend_3M_12M__c);
					if(doccus.EndDate__c <> NULL && doccus.Startdate__c <> NULL && doccus.Bounces_last_3_months__c <> NULL && doccus.Average_Balance_Trend__c <> NULL && doccus.Loan_Repayments_as_of_T_O_3_Mnths__c <> NULL && doccus.Transaction_Trend_3M_12M__c <> NULL && doccus.Turnover_Trend_3M_12M__c <> NULL )
						{//&& doccus.Transaction_Trend_3M_12M__c >= TransactionTrend

						}
                    if(doccus.Lead_Name__r.RLS_Category__c == 'Unsecured' || doccus.Lead_Name__r.RLS_Category__c == 'Secured') { 
						if(doccus.Correct_Overdraft__c == true && doccus.EndDate__c <= 31 && doccus.Startdate__c >= 350 && doccus.Bounces_last_3_months__c <=BouncesIn3Mnths && doccus.Average_Balance_Trend__c >=AVGBalenceTrend && doccus.Loan_Repayments_as_of_T_O_3_Mnths__c <= LoanRepaymentofTO && doccus.Turnover_Trend_3M_12M__c >= TurnOverTrend)
						{ 
							CustFinMaster = 'Green'; system.debug('Master Customer Financials -- '+CustFinMaster); 
						} 
						}else if(doccus.Lead_Name__r.RLS_Category__c.contains('ABL')) { 
									if(doccus.Correct_Overdraft__c == true && doccus.EndDate__c <= 31 && doccus.Startdate__c >= 350 && doccus.Bounces_last_3_months__c <=BouncesIn3Mnths && doccus.Turnover_Trend_3M_12M__c >= TurnOverTrend) { 
										CustFinMaster = 'Green'; system.debug('Master Customer Financials -- '+CustFinMaster); 
									}
						}
			}
        }
        
        if(listDoc.size() > 0)
        {
            for(Document_Statement__c doc : listDoc)
            {
                Date today = Date.today();
                if(!listdoc.isEmpty())
                {
                    system.debug('l.RLS_Category__c.touppercase()--'+l.RLS_Category__c.touppercase());
                    system.debug('Forecast_Account_Check__c'+doc.Forecast_Account_Check__c);
                    system.debug('l.RLS_Category__c.touppercase()--'+doc.Lead_Name__r.X12_Month_Forecasts__c);               
                    if((doc.Forecast_Account_Check__c == True && doc.Lead_Name__r.X12_Month_Forecasts__c == True && (l.RLS_Category__c.touppercase() =='SECURED' || l.RLS_Category__c.contains('ABL')))){
                        CompFinForecast = 'Green';
                        system.debug('Draft Check --- '+CompFinDraft);
                    }else if((doc.Forecast_Account_Check__c == False && doc.Lead_Name__r.X12_Month_Forecasts__c == True && (l.RLS_Category__c.touppercase() =='SECURED' || l.RLS_Category__c.contains('ABL')))){
                        CompFinForecast = 'Yellow';
                    }
                    if(doc.Lead_Name__r.Incorporation_Date__c.monthsBetween(today)>= IncorporationDate && doc.Last_Account_Period_End_on__c.monthsBetween(today) <= LastFiledAccDate){
                        Incorporation = 'Green';
                        system.debug('Incorporation Check --- '+Incorporation);
                    }
                    if(doc.Nucleus_Band_Rating__c == 'A' || doc.Nucleus_Band_Rating__c == 'B' || doc.Nucleus_Band_Rating__c == 'C') { 
							NucleusBand = 'Green'; system.debug('NucleusBand --- '+NucleusBand);
					}
                    if(doc.Incorporation_Date__c <> null && doc.Last_Account_Period_End_on__c <> Null){
                        if((doc.Management_Account_Check__c == True && doc.Lead_Name__r.Management_Accounts__c == True ) ||
											(doc.Draft_Account_Check__c == True && doc.Lead_Name__r.Draft_Accounts__c == True ) || (doc.Management_Account_Check__c == True &&
													doc.Lead_Name__r.Management_Accounts__c == True && doc.Draft_Account_Check__c == True && doc.Lead_Name__r.Draft_Accounts__c == True && 
															doc.End_Date_P_2__c.monthsBetween(today)<= EndDateAcc && doc.End_Date_P_1__c.monthsBetween(today)<= EndDateAcc) ||
																((doc.Audited_Accounts_Check__c == True || doc.P1_Mandatory_Check__c == True) &&
																doc.Lead_Name__r.Full_Audited_Accounts__c == True))
							{
									if(doc.End_Date_P_2__c <> NULL && doc.End_Date_P_1__c <> NULL){
										if(doc.End_Date_P_2__c.monthsBetween(today)<= EndDateAcc || doc.End_Date_P_1__c.monthsBetween(today)<= EndDateAcc )
										{
											Enddate = 'Green';
										}else
										{
											Enddate = 'Yellow';
										}
									}
									system.debug('Audit Check --- P1');
									////// Full Acc does not match with Credit Safe Date Period P1 //////
									 if(doc.Audited_Accounts_Check__c == True && doc.Lead_Name__r.Full_Audited_Accounts__c == True && doc.End_Date_P0__c == doc.Last_Account_Period_End_on__c && doc.CW_Date_Period_1__c <> doc.Last_Account_Period_End_on__c && doc.P1_Mandatory_Check__c) 
									 {
										system.debug('audit'); 
										if(doc.Incorporation_Date__c.monthsBetween(today)>= IncorporationDate && doc.Last_Account_Period_End_on__c.monthsBetween(today) < LastFiledAccDate) { 
											CompFinAudit = 'Green'; system.debug('Audit Check --- P0'+CompFinAudit); 
											} 
									}else 
                                ////// Full Acc match with Credit Safe Date Period P1 //////
                                if(doc.CW_Date_Period_1__c == doc.Last_Account_Period_End_on__c && doc.P1_Mandatory_Check__c) 
										{ 
											system.debug('Audit Check --- P1');
											system.debug('Audit Check '+doc.Last_Account_Period_End_on__c.monthsBetween(today));
											system.debug('Audit Check '+doc.Incorporation_Date__c.monthsBetween(today)); 
												if((doc.CW_Tangible_NW_P1__c <> NULL ) && (doc.CW_Profit_Lost_P1__c <> NULL ) && (doc.CW_Turnover_P1__c <> NULL && doc.CW_Turnover_P1__c >= Turnover) && (doc.Share_Premium_P1__c <> NULL && doc.Share_Premium_P1__c >= SharePremium) && (doc.Share_Capital_P1__c <> NULL && doc.Share_Capital_P1__c >= ShareCapital) && doc.Wages_Salaries__c >= SalaryWages && doc.Director_s_Salary__c >= DirectorSalary && doc.Incorporation_Date__c.monthsBetween(today)>= IncorporationDate) 
													{ 
														CompFinAudit = 'Green'; system.debug('Audit Check --- P1'+CompFinAudit); 
													}
														
										}
								if((doc.Management_Account_Check__c == True && doc.Lead_Name__r.Management_Accounts__c == True && ( doc.End_Date_P_2__c.monthsBetween(today)<= EndDateAcc || Enddate == 'Green')))
										{ 
											CompFinManagement = 'Green'; system.debug('Management Check --- '+CompFinManagement); 
										} 
								if((doc.Draft_Account_Check__c == True && doc.Lead_Name__r.Draft_Accounts__c == True && (Enddate == 'Green' || doc.End_Date_P_1__c.monthsBetween(today)<= EndDateAcc)))
										{ 
											CompFinDraft = 'Green'; system.debug('Draft Check --- '+CompFinDraft); 
										}//&& doc.End_Date_P_1__c.daysBetween(today)<= EndDateAcc)
                        }
                    }
                }
            }
        }
        //Added by Sri Harsha - Collateral Details IR
        list<Collateral_Details__c> cdList=[select id,Sales_Ops_Decision__c,Lead_Name__r.Quality_Check_Status__c from Collateral_Details__c where Lead_Name__c=:LeadId AND Lead_Name__r.RLS_Category__c like 'ABL%' AND (Sales_Ops_Decision__c='Incorrect' OR Sales_Ops_Decision__c='Review' OR Sales_Ops_Decision__c = NULL)];
        list<id> qualitycheck=new list<id>();
        if(cdList.size()>0)Collateral='Yellow';                             
        else Collateral='Green';        
        //Ended - Sri Harsha        
		
	}		
