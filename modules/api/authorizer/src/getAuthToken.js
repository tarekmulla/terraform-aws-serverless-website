/* eslint-disable no-console */
const AWS = require('aws-sdk');

const ssm = new AWS.SSM();

/**
 * Get the value of SSM parameter
 * @param {ssmParameterName} The full path of the SSM parameter
 * @returns the value of the parameter
 */
async function getAuthToken(ssmParameterName) {
  const options = {
    Name: ssmParameterName,
    WithDecryption: true,
  };

  return ssm
    .getParameter(options)
    .promise()
    .then((data) => data?.Parameter?.Value)
    .catch((e) => {
      console.log(e);
      throw new Error(e);
    });
}

module.exports = {
  getAuthToken,
};
