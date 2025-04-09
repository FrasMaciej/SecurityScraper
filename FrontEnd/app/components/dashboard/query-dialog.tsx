import { DialogTrigger } from "../ui/dialog";
import { createFormHook, createFormHookContexts } from "@tanstack/react-form";
import { Button } from "../ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "../ui/dialog";
import { Plus, Search, Trash } from "lucide-react";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { Checkbox } from "../ui/checkbox";
import FilterSelect from "./filter-select";

export function QueryDialog() {
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
      </DialogContent>
    </Dialog>
  );
}
