import { Button } from "@/components/ui/button";
import { createFileRoute, useLoaderData } from "@tanstack/react-router";
import { callLambdaFunction } from "@/api/collector-api";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useState } from "react";
import { ShodanApiGuidelines } from "@/components/dashboard/shodan-api-guidelines";
import { createFormHook, createFormHookContexts } from "@tanstack/react-form";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import FilterSelect from "@/components/dashboard/filter-select";
import { Label } from "@/components/ui/label";
import { Plus, Trash } from "lucide-react";
import { z } from "zod";

const { fieldContext, formContext } = createFormHookContexts();
const { useAppForm } = createFormHook({
  fieldComponents: {
    Checkbox,
    Input,
    FilterSelect,
  },
  formComponents: {
    SubmitButton: () => <Button type="submit">Submit</Button>,
  },
  fieldContext,
  formContext,
});

export const Route = createFileRoute("/dashboard")({
  component: RouteComponent,
});

const schema = z.object({
  page: z.number().min(1).max(100),
  minify: z.boolean(),
  filters: z.array(
    z.object({
      key: z.string().min(1),
      value: z.string().min(1),
    })
  ),
});

function RouteComponent() {
  const url = useLoaderData({ from: "__root__" });
  const [jsonData, setJsonData] = useState({
    "You will see the response here": "after you click the button",
  });
  const [sendRequestButtonActive, setSendRequestButtonActive] = useState(true);

  const form = useAppForm({
    defaultValues: {
      page: 1,
      minify: true,
      filters: [
        {
          key: "ip",
          value: "",
        },
      ],
    },
    validators: {
      onChange: schema,
    },
    onSubmitInvalid: (data) => {
      console.log(data);
    },
    onSubmit: async ({ value }) => {
      const query = value.filters
        .map((filter) => `${filter.key}=${filter.value}`)
        .join("&");
      try {
        const json = await callLambdaFunction(
          url,
          query + `&page=${value.page}`
        );
        setJsonData(json);
      } catch (error) {
        console.error(error);
      }
    },
  });

  return (
    <div className="mx-4 grid grid-cols-2 gap-4 min-h-1/2">
      <Card className="min-h-9/12">
        <CardHeader>
          <CardTitle>
            <h1>Shodan Query</h1>
          </CardTitle>
        </CardHeader>
        <CardContent className="flex-1">
          <form
            id="shodan-query-form"
            onSubmit={async (e) => {
              e.preventDefault();
              await form.handleSubmit();
            }}
            className="space-y-4"
          >
            <div className="grid grid-cols-2 gap-4">
              <form.AppField
                name="page"
                children={(field) => (
                  <div className="space-y-1">
                    <Label>Page</Label>
                    <field.Input
                      type="number"
                      value={field.state.value}
                      onChange={(e) => field.setValue(Number(e.target.value))}
                    />
                  </div>
                )}
              />
            </div>
            <div>
              <div className="flex gap-2 mb-1">
                <Label>Filters</Label>
                <form.AppField
                  name="filters"
                  children={(field) => (
                    <Button
                      type="button"
                      variant="outline"
                      size={null}
                      onClick={() => field.pushValue({ key: "", value: "" })}
                    >
                      <Plus className="size-3" />
                    </Button>
                  )}
                />
              </div>
              <form.AppField
                name="filters"
                mode="array"
                children={(field) => (
                  <div className="flex flex-col gap-2">
                    {field.state.value.map((_, i) => (
                      <div key={i} className="flex gap-2">
                        <div className="flex">
                          <form.AppField
                            name={`filters[${i}].key`}
                            children={(field) => (
                              <FilterSelect
                                onChange={field.setValue}
                                value={field.state.value}
                              />
                            )}
                          />
                          <div className="border-t border-b border-input bg-card w-4 grid place-items-center shadow-xs">
                            :
                          </div>
                          <form.AppField
                            name={`filters[${i}].value`}
                            children={(field) => (
                              <field.Input
                                className="rounded-r-md rounded-l-none w-48"
                                placeholder="Filter value"
                                value={field.state.value}
                                onChange={(e) => {
                                  field.setValue(e.target.value);
                                }}
                              />
                            )}
                          />
                        </div>
                        <Button
                          type="button"
                          variant="outline"
                          size="default"
                          onClick={() => field.removeValue(i)}
                        >
                          <Trash className="size-3.5" />
                        </Button>
                      </div>
                    ))}
                  </div>
                )}
              />
            </div>
          </form>
        </CardContent>
        <CardFooter>
          <div className="flex gap-2 justify-between w-full">
            <Button
              variant="outline"
              type="button"
              onClick={() => form.reset()}
            >
              Reset
            </Button>
            <Button type="submit" form="shodan-query-form">
              Submit
            </Button>
          </div>
        </CardFooter>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>
            <h1>Results</h1>
          </CardTitle>
          <CardContent>
            <pre>{JSON.stringify(jsonData, null, 2)}</pre>
          </CardContent>
        </CardHeader>
      </Card>
    </div>
  );
}
