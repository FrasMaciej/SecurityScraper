import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { createFileRoute } from "@tanstack/react-router";
import { callLambdaFunction } from "@/api/collector-api";
import { Card, CardContent } from "@/components/ui/card";
import { useState } from "react";

export const Route = createFileRoute("/dashboard")({
  component: RouteComponent,
});

function RouteComponent() {
  const [jsonData, setJsonData] = useState({});
  const [sendRequestButtonActive, setSendRequestButtonActive] = useState(true);

  async function getDataFromShodanAPI() {
    setSendRequestButtonActive(false);
    try {
      const json = await callLambdaFunction();
      setJsonData(json);
    } catch (error) {
      console.error("Error calling Lambda function:", error);
    } finally {
      setSendRequestButtonActive(true);
    }
  }

  return (
    <div className="m-4">
      <div className="grid w-full gap-2">
        <Textarea placeholder="Insert your query to search with Shodan API here - leave blank for test call" />
        <div className="flex justify-center">
          <Button
            disabled={!sendRequestButtonActive}
            className="clickable"
            onClick={getDataFromShodanAPI}
          >
            Send request
          </Button>
        </div>
        <Card className="bg-muted text-sm overflow-auto max-h-[500px]">
          <CardContent>
            <pre className="whitespace-pre-wrap break-words">
              <code>{JSON.stringify(jsonData, null, 2)}</code>
            </pre>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
