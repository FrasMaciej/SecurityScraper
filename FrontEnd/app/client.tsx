/// <reference types="vinxi/types/client" />
import { hydrateRoot } from "react-dom/client";
import { StartClient } from "@tanstack/react-start";
import { createRouter } from "./router";
import { AuthProvider } from "react-oidc-context";

const router = createRouter();

const cognitoAuthConfig = {
  authority: "https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_qm1JV0IeW",
  client_id: "366vncd3k3harj5t24ojf88ug3",
  redirect_uri: "https://lt4fop4ihlbrptsqxumwqz7w5u0wtxee.lambda-url.eu-central-1.on.aws/",
  response_type: "code",
  scope: "email openid profile",
};

hydrateRoot(
  document,
  <AuthProvider {...cognitoAuthConfig}>
    <StartClient router={router} />
  </AuthProvider>
);
