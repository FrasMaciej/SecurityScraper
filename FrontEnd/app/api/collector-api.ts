// const lambdaUrl = import.meta.env.VITE_SHODAN_LAMBDA_COLLECTOR_URL;
const lambdaUrl = 'https://v5mxjroe5nxlgxrykpdui3poum0ufeix.lambda-url.eu-central-1.on.aws/'

export async function callLambdaFunction() {
  try {
    console.log('Calling Lambda function at:', lambdaUrl);
    const response = await fetch(lambdaUrl, {
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({}), 
    });

    if (!response.ok) {
      throw new Error(`Lambda call failed with status ${response.status}`);
    }

    const data = await response.json();
    console.log('Lambda response data:', data);
    return data;
  } catch (error) {
    console.error('Error calling Lambda function:', error);
  }
}