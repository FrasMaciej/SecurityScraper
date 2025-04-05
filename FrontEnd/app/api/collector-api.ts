const lambdaUrl = import.meta.env.VITE_SHODAN_LAMBDA_COLLECTOR_URL;

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
  } catch (error) {
    console.error('Error calling Lambda function:', error);
  }
}