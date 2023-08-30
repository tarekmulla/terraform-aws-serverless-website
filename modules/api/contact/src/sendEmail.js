const AWS = require('aws-sdk');
const SES = new AWS.SES();

const SENDER_EMAIL = "no-reply@mulla.au";
const RECEIVER_EMAIL = "tarek@mulla.au";

async function sendEmail(email, message, name) {
  const params = {
    Destination: {
      ToAddresses: [RECEIVER_EMAIL],
    },
    Message: {
      Body: {
        Html: {
          Data: "A contact message received from " + name + ", email: " + email + ", the messsage is: " + message
        }
      },
      Subject: {
        Data: "Contact message from personal website"
      },
    },
    Source: SENDER_EMAIL
  };
  await SES.sendEmail(params).promise();
}

module.exports = {
  sendEmail
};
