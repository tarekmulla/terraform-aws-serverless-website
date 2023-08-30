const { apiResponse, jsonEscape } = require('/opt/nodejs/utility');
const { sendEmail } = require('./sendEmail');

module.exports.handler = async (event) => {
  let res;
  let email;
  let message;
  let name;
  try {
    if (event.body !== null && event.body !== undefined) {
      let bodyContent = jsonEscape(event.body);
      let body = JSON.parse(bodyContent);
      console.info(body);
      if (body.name)
        name = body.name;
      if (body.email && body.message) {
        email = body.email;
        message = body.message;
      }
      else {
        throw new Error("Request body missing required parameters");
      }
    }
    else {
      throw new Error("The request body is not valid");
    }
    await sendEmail(email, message, name);
    res = {
      statusCode: 200,
      payload: {
        message: "Email sent successfully!",
      }
    };
  }
  catch (error) {
    console.error(error);
    res = {
      statusCode: 400,
      payload: {
        message: "Sending email failed!",
      }
    };
  }
  return apiResponse(res);
};
