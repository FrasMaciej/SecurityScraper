export async function callLambdaFunction(url: string) {
  try {
    console.log("Calling Lambda function at:", url);
    const response = await fetch(`${url}collect`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({}),
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
