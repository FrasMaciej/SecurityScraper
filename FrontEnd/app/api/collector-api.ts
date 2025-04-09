export async function callLambdaFunction(url: string, body: any) {
  try {
    console.log("Calling Lambda function at:", url);
    const response = await fetch(`${url}/collect`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      throw new Error(`Lambda call failed with status ${response.status}`);
    }

    const data = await response.json();
    console.log("Lambda response data:", data);
    return data;
  } catch (error) {
    console.error("Error calling Lambda function:", error);
  }
}
