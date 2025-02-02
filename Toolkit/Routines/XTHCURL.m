XTHCURL ;HCIOFO/SG - HTTP 1.0 CLIENT (URL TOOLS) ;Oct 02, 2018@13:37
 ;;7.3;TOOLKIT;**123,10002**;Apr 25, 1995;Build 4
 Q
 ; (c) Sam Habiel 2015-2018 *10002*
 ; See repository for license terms.
 ; *10002* - TLS Support
 ; See code for *10002* markers for modified code.
 ;***** ENCODES THE STRING
 ;
 ; STR           String to be encoded
 ;
ENCODE(STR) ;
 N CH,I
 F I=1:1  S CH=$E(STR,I)  Q:CH=""  I CH?1CP  D
 . I CH="." Q
 . I CH=" "  S $E(STR,I)="+"  Q
 . S $E(STR,I)="%"_$$RJ^XLFSTR($$CNV^XLFUTL($A(CH),16),2,"0"),I=I+2
 Q STR
 ;
 ;##### CREATES URL FROM COMPONENTS
 ;
 ; HOST          Host name
 ; [PORT]        Port number (80, by default)
 ; [PATH]        Resource path ("/", by default)
 ;
 ; [.QUERY]      Reference to a local variable containing values of
 ;               the query parameters: QUERY(Name)=Value.
 ;
 ; Return values:
 ;           <0  Error Descriptor
 ;          ...  Resulting URL
 ;
MAKEURL(HOST,PORT,PATH,QUERY) ;
 N NAME,QSTR,VAL
 S:HOST'["://" HOST="http://"_HOST
 S PORT=$S($G(PORT)>0:":"_(+PORT),1:"")
 ;---
 S (NAME,QSTR)=""
 F  S NAME=$O(QUERY(NAME))  Q:NAME=""  D
 . S VAL=$G(QUERY(NAME))
 . S QSTR=QSTR_"&"_$$ENCODE(NAME)_"="_$$ENCODE(VAL)
 S:QSTR'="" $E(QSTR,1)="?"
 ;---
 S:$G(PATH)="" PATH="/"
 Q HOST_PORT_$$NORMPATH($G(PATH)_QSTR)
 ;
 ;##### RETURNS "NORMALIZED" PATH
 ;
 ; PATH          Source path
 ;
NORMPATH(PATH) ;
 N LAST
 ;--- Make sure the path has a leading slash if it
 ;--- is not empty and has no query string
 I $E(PATH,1)'="/"  S:$E(PATH,1)'="?" PATH="/"_PATH
 ;--- Append a trailing slash to the path if it has
 ;--- neither a file name nor a query string
 S LAST=$L(PATH,"/"),LAST=$P(PATH,"/",LAST)
 ;I LAST'="",LAST'["?",LAST'["."  S PATH=PATH_"/" ; smh commented out *10002*
 Q PATH
 ;
 ;##### PARSES THE URL INTO COMPONENTS
 ;
 ; URL           Source URL
 ;
 ; .HOST         Reference to a local variable for the host name
 ; .PORT         Reference to a local variable for the port number
 ; .PATH         Reference to a local variable for the path
 ; .ISTLS        Reference to a local variable for TLS/SSL
 ;
 ; Return values:
 ;           <0  Error Descriptor
 ;            0  Ok
 ;
PARSEURL(URL,HOST,PORT,PATH,ISTLS)	; *10002* - Add ISTLS
 ; *10002*
 N TLSSTR S TLSSTR="HTTPS://"
 N TLSSTRL S TLSSTRL=$L(TLSSTR)
 S ISTLS=$E($$UP^XLFSTR(URL),1,TLSSTRL)=TLSSTR
 ; /*10002*
 ;
 S:$F(URL,"://") URL=$P(URL,"://",2,999)
 S HOST=$TR($P(URL,"/")," ")
 S PATH=$$NORMPATH($P(URL,"/",2,999))
 S PORT=$P(HOST,":",2),HOST=$P(HOST,":")
 Q:HOST?." " $$ERROR^XTHC10(1,URL)
 S:PORT'>0 PORT=$S(ISTLS:443,1:80) ; *10002*
 Q 0
