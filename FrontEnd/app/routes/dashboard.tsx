import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { createFileRoute } from "@tanstack/react-router";
import { callLambdaFunction } from "@/api/collector-api";
import { Card, CardContent } from "@/components/ui/card";
import { useState } from "react";
import { ShodanApiGuidelines } from "@/components/dashboard/shodan-api-guidelines";

export const Route = createFileRoute("/dashboard")({
  component: RouteComponent,
});

function RouteComponent() {
  const [jsonData, setJsonData] = useState({
    "You will see the response here": "after you click the button",
  });
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
        <div className="flex justify-center">
          <ShodanApiGuidelines></ShodanApiGuidelines>
        </div>
        <div className="flex justify-center">
          <Textarea
            className="w-1/2"
            placeholder="Insert your query to search with Shodan API here - leave blank for test call that returs available credits"
          />
        </div>
        <div className="flex justify-center">
          <Button
            disabled={!sendRequestButtonActive}
            className="clickable"
            onClick={getDataFromShodanAPI}
          >
            Send request
          </Button>
        </div>
        <div className="flex justify-center">
          <Card className="bg-muted text-sm overflow-auto max-h-[1200px] w-3/4">
            <CardContent>
              <pre className="whitespace-pre-wrap break-words">
                <code>{JSON.stringify(jsonData, null, 2)}</code>
              </pre>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
