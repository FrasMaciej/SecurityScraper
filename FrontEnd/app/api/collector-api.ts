export async function callLambdaFunction(url: string, query: string) {
  try {
    console.log("Calling Lambda function at:", url);
    const response = await fetch(`${url}/collect?${query}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
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
