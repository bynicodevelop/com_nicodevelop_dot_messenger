import {createTransport} from "nodemailer";
import {readFileSync} from "fs";
import {compile} from "handlebars";
import {info} from "firebase-functions/logger";
import {resolve} from "path";
// import * as SparkPost from "sparkpost";

import {
  appName,
  appMailHost,
  appMailPort,
  appMailUsername,
  appMailPassword,
  appMailFromEmail,
  appMailFromName,
  appMailTemplateVerifyEmailSubject,
  appMailTemplateDeleteAccountSubject,
} from "../config";

export const sendEmail = async (
    subject: string,
    email: string,
    template: string
): Promise<void> => {
  info("Send email", {subject, email});

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const configOptions: any = {
    host: appMailHost.value(),
    port: appMailPort.value(),
    secure: false,
    auth: {
      user: appMailUsername.value(),
      pass: appMailPassword.value(),
    },
    tls: {
      rejectUnauthorized: true,
      minVersion: "TLSv1.2",
    },
  };

  const transporter = createTransport(configOptions);

  const mailOptions = {
    from: `"${appMailFromName.value()}" <${appMailFromEmail.value()}>`,
    to: email,
    subject: subject,
    html: template,
  };

  await transporter.sendMail(mailOptions);
};


const convertTemplate = (
    templateName: string,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    data: any
): string => {
  info("Create template", {templateName, data});

  const template = readFileSync(
      resolve(
          __dirname,
          `../../../assets/mails/templates/${templateName}.html`
      ),
      "utf8"
  );

  const templateFunction = compile(template);

  return templateFunction({
    ...data,
    app_name: appName.value(),
  });
};

export const sendCodeVerification = async (
    email: string,
    code: string,
): Promise<void> => {
  info("Send code verification");

  const emailTemplate = convertTemplate(
      "verification_email",
      {code}
  );

  await sendEmail(
      appMailTemplateVerifyEmailSubject.value(),
      email,
      emailTemplate
  );
};

export const sendConfirmationDeleteAccount = async (
    email: string,
): Promise<void> => {
  info("Send confirmation delete account");

  const emailTemplate = convertTemplate(
      "confirmation_delete_account",
      {}
  );

  await sendEmail(
      appMailTemplateDeleteAccountSubject.value(),
      email,
      emailTemplate
  );
};
