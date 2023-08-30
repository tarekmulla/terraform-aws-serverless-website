const { getAuthToken } = require('./getAuthToken');

/** Generate policy that allows the request and let the request proceed to the backing resource
 *
 */
function generatePolicy(principalId, effect, resource) {
  const authResponse = {};

  authResponse.principalId = principalId;
  if (effect && resource) {
    const policyDocument = {};
    policyDocument.Version = '2012-10-17';
    policyDocument.Statement = [];
    const statementOne = {};
    statementOne.Action = 'execute-api:Invoke';
    statementOne.Effect = effect;
    statementOne.Resource = resource;
    policyDocument.Statement[0] = statementOne;
    authResponse.policyDocument = policyDocument;
  }
  return authResponse;
}

module.exports.handler = async (event) => {
  // extract the token from the request
  const token = event.authorizationToken;
  // get the stored token from SSM parameter store
  const appAuthToken = await getAuthToken(`/${process.env.APP}/${process.env.ENV}/api_auth_token`);

  // generate policy that allows the request if the token is correct
  if (token === appAuthToken) {
    return generatePolicy('user', 'Allow', event.methodArn);
  }
  throw new Error('Unauthorized');
};
