"use client";

import * as React from "react";
import { ChevronsUpDown } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import * as queries from "./examples_queries/queries";
import { Card, CardContent } from "../ui/card";

export function ShodanApiGuidelines() {
  const [isOpen, setIsOpen] = React.useState(false);

  return (
    <Collapsible
      open={isOpen}
      onOpenChange={setIsOpen}
      className="w-[700px] space-y-2 mb-8"
    >
      <div className="flex items-center justify-between space-x-4 px-4">
        <h4 className="text-sm font-semibold">Collapse example API queries</h4>
        <CollapsibleTrigger asChild>
          <Button variant="ghost" size="sm" className="w-9 p-0">
            <ChevronsUpDown className="h-4 w-4" />
            <span className="sr-only">Toggle</span>
          </Button>
        </CollapsibleTrigger>
      </div>
      <CollapsibleContent className="space-y-2 flex flex-col items-center">
        Kuberentes dashboards
        <Card className="bg-muted text-sm overflow-auto max-h-[1200px] w-3/4">
          <CardContent>
            <pre className="whitespace-pre-wrap break-words">
              <code>{JSON.stringify(queries.kuberentesQuery, null, 2)}</code>
            </pre>
          </CardContent>
        </Card>
        Port 22
        <Card className="bg-muted text-sm overflow-auto max-h-[1200px] w-3/4">
          <CardContent>
            <pre className="whitespace-pre-wrap break-words">
              <code>{JSON.stringify(queries.port22Query, null, 2)}</code>
            </pre>
          </CardContent>
        </Card>
      </CollapsibleContent>
    </Collapsible>
  );
}
