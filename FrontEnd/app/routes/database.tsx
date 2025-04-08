import { useEffect, useState } from "react";
import {
  Accordion,
  AccordionItem,
  AccordionTrigger,
  AccordionContent,
} from "@/components/ui/accordion";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/database")({
  component: RouteComponent,
});

function RouteComponent() {
  const [data, setData] = useState<any[]>([
    { data1: "value1", data2: "value2" },
    { data1: "value3", data2: "value4" },
    { data1: "value5", data2: "value6" },
    { data1: "value7", data2: "value8" },
    { data1: "value9", data2: "value10" },
    { data1: "value11", data2: "value12" },
    { data1: "value13", data2: "value14" },
    { data1: "value15", data2: "value16" },
    { data1: "value17", data2: "value18" },
    { data1: "value19", data2: "value20" },
    { data1: "value21", data2: "value22" },
    { data1: "value23", data2: "value24" },
    { data1: "value25", data2: "value26" },
    { data1: "value27", data2: "value28" },
    { data1: "value29", data2: "value30" },
  ]);

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Database Records</h1>
      {data.length === 0 ? (
        <p>No records found.</p>
      ) : (
        <Accordion type="single" collapsible className="w-full">
          {data.map((item, index) => (
            <AccordionItem key={index} value={`item-${index}`}>
              <AccordionTrigger>Record {index + 1}</AccordionTrigger>
              <AccordionContent>
                <pre className="bg-gray-100 p-2 rounded-md text-sm">
                  {JSON.stringify(item, null, 2)}
                </pre>
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      )}
    </div>
  );
}
