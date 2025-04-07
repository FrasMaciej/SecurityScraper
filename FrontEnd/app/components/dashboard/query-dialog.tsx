import { DialogTrigger } from "../ui/dialog";
import { createFormHook, createFormHookContexts } from "@tanstack/react-form";
import { Button } from "../ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "../ui/dialog";
import { Plus, Search, Trash } from "lucide-react";
import { z } from "zod";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { Checkbox } from "../ui/checkbox";
import FilterSelect from "./filter-select";

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

export function QueryDialog() {
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
    // validators: {
    //   onChange: schema,
    // },
    onSubmitInvalid: (data) => {
      console.log(data);
    },
    onSubmit: async ({ value, meta }) => {
      console.log("submitted");

      const baseUrl = "https://api.shodan.io/shodan/host/search";
      const params = data.value.filters
        .map((filter) => `${filter.key}:${filter.value}`)
        .join(" ");
      const url = `${baseUrl}?query=${params}&page=${data.value.page}`;
      try {
        const response = await fetch(url);
        const data = await response.json();
        console.log(data);
      } catch (error) {
        console.error(error);
      }
    },
  });

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>
          <Search className="size-3.5" />
          Query
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Query Shodan API</DialogTitle>
        </DialogHeader>
        <div className="space-y-1 mb-2">
          <Label>Natural language query input</Label>
          <Input placeholder="Tell me what you want to search for" />
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            form.handleSubmit();
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
                    <div key={i} className="flex gap-2 justify-between">
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
                        <div className="border-t border-b border-border w-4 grid place-items-center bg-background">
                          :
                        </div>
                        <form.AppField
                          name={`filters[${i}].value`}
                          children={(field) => (
                            <field.Input
                              className="rounded-r-md rounded-l-none w-48"
                              placeholder="Filter value"
                            />
                          )}
                        />
                      </div>
                      <Button
                        type="button"
                        variant="outline"
                        className="ml-2"
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
            <div className="flex gap-2 justify-between mt-6">
              <Button
                variant="outline"
                type="button"
                onClick={() => form.reset()}
              >
                Reset
              </Button>
              <form.AppForm>
                <form.SubmitButton />
              </form.AppForm>
            </div>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}
