import { Popover, PopoverContent, PopoverTrigger } from "../ui/popover";
import { Button } from "../ui/button";
import { Check, ChevronDown } from "lucide-react";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "../ui/command";
import { useState } from "react";
import { cn } from "@/lib/utils";

const parseChildren = (children: string) => {
  const label = children.split(".").pop() ?? children;
  return {
    label: label.charAt(0).toUpperCase() + label.slice(1),
    value: children,
  };
};

const data = [
  {
    title: "General",
    children: [
      "all",
      "asn",
      "city",
      "country",
      "cpe",
      "device",
      "geo",
      "has_ipv6",
      "has_screenshot",
      "has_ssl",
      "has_vuln",
      "hash",
      "hostname",
      "ip",
      "isp",
      "link",
      "net",
      "org",
      "os",
      "port",
      "postal",
      "product",
      "region",
      "scan",
      "shodan.module",
      "state",
      "version",
    ].map(parseChildren),
  },
  {
    title: "Screenshots",
    children: ["screenshot.hash", "screenshot.label"].map(parseChildren),
  },
  {
    title: "Cloud",
    children: ["cloud.provider", "cloud.region", "cloud.service"].map(
      parseChildren
    ),
  },
  {
    title: "HTTP",
    children: [
      "http.component",
      "http.component_category",
      "http.dom_hash",
      "http.favicon.hash",
      "http.headers_hash",
      "http.html",
      "http.html_hash",
      "http.robots_hash",
      "http.securitytxt",
      "http.server_hash",
      "http.status",
      "http.title",
      "http.title_hash",
      "http.waf",
    ].map(parseChildren),
  },
  {
    title: "Bitcoin",
    children: [
      "bitcoin.ip",
      "bitcoin.ip_count",
      "bitcoin.port",
      "bitcoin.version",
    ].map(parseChildren),
  },
  {
    title: "SNMP",
    children: ["snmp.contact", "snmp.location", "snmp.name"].map(parseChildren),
  },
  {
    title: "SSL",
    children: [
      "ssl",
      "ssl.alpn",
      "ssl.cert.alg",
      "ssl.cert.expired",
      "ssl.cert.extension",
      "ssl.cert.fingerprint",
      "ssl.cert.issuer.cn",
      "ssl.cert.pubkey.bits",
      "ssl.cert.pubkey.type",
      "ssl.cert.serial",
      "ssl.cert.subject.cn",
      "ssl.chain_count",
      "ssl.cipher.bits",
      "ssl.cipher.name",
      "ssl.cipher.version",
      "ssl.ja3s",
      "ssl.jarm",
      "ssl.version",
    ].map(parseChildren),
  },
  {
    title: "NTP",
    children: ["ntp.ip", "ntp.ip_count", "ntp.more", "ntp.port"].map(
      parseChildren
    ),
  },
  {
    title: "Telnet",
    children: [
      "telnet.do",
      "telnet.dont",
      "telnet.option",
      "telnet.will",
      "telnet.wont",
    ].map(parseChildren),
  },
  {
    title: "SSH",
    children: ["ssh.hassh", "ssh.type"].map(parseChildren),
  },
];

export default function FilterSelect({
  onChange,
  value,
}: {
  onChange: (value: string) => void;
  value: string;
}) {
  const [open, setOpen] = useState(false);

  const handleSelect = (selectedValue: string) => {
    onChange(selectedValue);
    setOpen(false);
  };

  return (
    <Popover modal open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          className="w-48 justify-start capitalize rounded-l-md rounded-r-none"
        >
          <span className="truncate">
            {value
              ? data
                  .find((d) => d.children.some((c) => c.value === value))
                  ?.children.find((c) => c.value === value)?.label
              : "Select filter..."}
          </span>
          <ChevronDown className="ml-auto h-4 w-4 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-[300px] p-0">
        <Command>
          <CommandInput placeholder="Search filters..." />
          <CommandList>
            <CommandEmpty>No results found.</CommandEmpty>
            {data.map((group) => (
              <CommandGroup key={group.title} heading={group.title}>
                {group.children.map((child) => (
                  <CommandItem
                    className="!pointer-events-auto"
                    key={child.value}
                    value={child.value}
                    onSelect={() => handleSelect(child.value)}
                  >
                    <Check
                      className={cn(
                        "mr-2 h-4 w-4",
                        value === child.value ? "opacity-100" : "opacity-0"
                      )}
                    />
                    {child.label}
                  </CommandItem>
                ))}
              </CommandGroup>
            ))}
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
}
