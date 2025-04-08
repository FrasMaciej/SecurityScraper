// app/routes/__root.tsx
import type { ReactNode } from "react";
import {
  Outlet,
  createRootRoute,
  HeadContent,
  Scripts,
} from "@tanstack/react-router";
import css from "@/styles/index.css?url";
import Layout from "@/layout/layout";

import { AuthProvider } from "react-oidc-context";

const cognitoAuthConfig = {
  authority: "https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_YpCL3R2lN",
  client_id: "7ksbde85h870vrn26rdrmkihno",
  redirect_uri: "https://yxn4iyv2w4mqi6tvimwwu6n3cq0vigfx.lambda-url.eu-central-1.on.aws/",
  response_type: "code",
  scope: "email openid profile",
  };

export const Route = createRootRoute({
  head: () => ({
    meta: [
      {
        charSet: "utf-8",
      },
      {
        name: "viewport",
        content: "width=device-width, initial-scale=1",
      },
      {
        title: "TanStack Start Starter",
      },
    ],
    links: [
      {
        rel: "stylesheet",
        href: css,
      },
    ],
  }),
  component: RootComponent,
  notFoundComponent: () => <div>Not Found</div>,
  loader: () => {
    const data = process.env.SECURITY_SCRAPER_API_GATEWAY_URL ?? "";
    return data;
  },
});

function RootComponent() {
  return (
    <AuthProvider {...cognitoAuthConfig}>
      <RootDocument>
        <Layout>
          <Outlet />
        </Layout>
      </RootDocument>
    </AuthProvider>
  );
}

function RootDocument({ children }: Readonly<{ children: ReactNode }>) {
  return (
    <html>
      <head>
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  );
}
