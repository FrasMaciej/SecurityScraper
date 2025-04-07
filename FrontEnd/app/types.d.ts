type ShodanLocation = {
  city: string | null;
  region_code: string | null;
  area_code: number | null;
  longitude: number;
  country_code3: string | null;
  latitude: number;
  postal_code: string | null;
  dma_code: number | null;
  country_code: string;
  country_name: string;
};

type ShodanHttp = {
  robots_hash: number | null;
  redirects: string[];
  securitytxt: string | null;
  title: string;
  sitemap_hash: number | null;
  robots: string | null;
  server: string;
  host: string;
  html: string;
  location: string;
  components: Record<string, unknown>;
  securitytxt_hash: number | null;
  sitemap: string | null;
  html_hash: number;
};

type ShodanMetadata = {
  crawler: string;
  ptr: boolean;
  id: string;
  module: string;
  options: Record<string, unknown>;
};

type ShodanMatch = {
  product: string;
  hash: number;
  ip: number;
  org: string;
  isp: string;
  transport: string;
  cpe: string[];
  data: string;
  asn: string;
  port: number;
  hostnames: string[];
  location: ShodanLocation;
  timestamp: string;
  domains: string[];
  http: ShodanHttp;
  os: string | null;
  _shodan: ShodanMetadata;
  ip_str: string;
  version?: string;
};

type ShodanFacetItem = {
  count: number;
  value: string;
};

type ShodanFacets = {
  country: ShodanFacetItem[];
};

type ShodanResponse = {
  matches: ShodanMatch[];
  facets: ShodanFacets;
  total: number;
};
