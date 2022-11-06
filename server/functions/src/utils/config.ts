import {defineInt, defineString} from "firebase-functions/params";

export const appName = defineString("APP_NAME");

export const appMailFromName = defineString("APP_MAIL_FROM_NAME");
export const appMailFromEmail = defineString("APP_MAIL_FROM_EMAIL");

export const appMailHost = defineString("APP_MAIL_HOST");
export const appMailPort = defineInt("APP_MAIL_PORT");
export const appMailUsername = defineString("APP_MAIL_USERNAME");
export const appMailPassword = defineString("APP_MAIL_PASSWORD");

export const appMailTemplateVerifyEmailSubject =
    defineString("APP_MAIL_TEMPLATE_VERIFY_EMAIL_SUBJECT");

export const appMailTemplateDeleteAccountSubject =
    defineString("APP_MAIL_TEMPLATE_DELETE_ACCOUNT_SUBJECT");
