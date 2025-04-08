import * as React from "react";
import { useAuth } from "react-oidc-context";
import {
  IconDashboard,
  IconShieldLock,
  IconListDetails,
  IconCoin,
} from "@tabler/icons-react";

import { NavMain } from "@/components/nav-main";
import { NavUser } from "@/components/nav-user";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";
import { Link } from "@tanstack/react-router";

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  const auth = useAuth();
const isLoggedIn = auth.isAuthenticated && auth.user;
const data = {
  user: {
    name: isLoggedIn ? auth.user?.profile?.name ?? "No Name" : "Anonymous",
    email: isLoggedIn ? auth.user?.profile?.email ?? "" : "",
    avatar: "/avatars/shadcn.jpg",
  },
  navMain: [
    {
      title: "Dashboard",
      url: "/dashboard",
      icon: IconDashboard,
    },
    {
      title: "Database",
      url: "/database",
      icon: IconListDetails,
    },
    {
      title: "Billing",
      url: "/billing",
      icon: IconCoin,
    },
  ],
};


  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              asChild
              className="data-[slot=sidebar-menu-button]:!p-1.5"
            >
              <Link to="/">
                <IconShieldLock className="!size-5" />
                <span className="text-base font-semibold">
                  Security Scraper
                </span>
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <NavMain items={data.navMain} />
      </SidebarContent>
      <SidebarFooter>
        <NavUser user={data.user} />
      </SidebarFooter>
    </Sidebar>
  );
}
