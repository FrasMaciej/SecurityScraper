import { useEffect, useState } from "react";
import {
  Accordion,
  AccordionItem,
  AccordionTrigger,
  AccordionContent,
} from "@/components/ui/accordion";
import { createFileRoute, useLoaderData } from "@tanstack/react-router";

export const Route = createFileRoute("/database")({
  component: RouteComponent,
});

function RouteComponent() {
  const url = useLoaderData({ from: "__root__" });

  const [data, setData] = useState<any[]>([]); // Start with an empty array

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`${url}/get-reports`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        });
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        const result = await response.json();
        console.log(result);
        setData(result); // Set the fetched data
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, [url]);

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Database Records</h1>
      {data.length === 0 ? (
        <p>No records found.</p>
      ) : (
        <Accordion type="single" collapsible className="w-full">
          {data.map((item, index) => (
            <AccordionItem key={index} value={`item-${index}`}>
              <AccordionTrigger>
                {item.PrimaryKey || `Record ${index + 1}`}
              </AccordionTrigger>
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
