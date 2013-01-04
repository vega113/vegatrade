function [isSent] = sendGMail(attchFileName,msgTxt)
% Define these variables appropriately:
mail = 'xxxoxomail01@gmail.com'; %Your GMail email address
password = 'xoxo_ver5'; %Your GMail password

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

if ~isempty(msgTxt)
    [k v] = size(msgTxt);
    strm = msgTxt(1,:);
    for hhj =2:max(1,k)
        strm = strcat(strm,'\n',msgTxt(hhj,:),'\n');
    end
    sendmail('vega113@gmail.com','Intermediate result ',strm);
end
% Send the email
if ~isempty(attchFileName)
   sendmail('vega113@gmail.com','TestRun result is ready ','Hello! Test result is ready !!! :)');
try
    sendmail('vega113@gmail.com','TestRun result ','Hello! This new simulation result is ready! I hope it is  good  !!! :)',{attchFileName});
catch me
    disp('failed to send email :( ');
    isSent = false;
    return
end
isSent = true;
end
