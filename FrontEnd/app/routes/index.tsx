import { createFileRoute } from "@tanstack/react-router";
import { Button, Space, DatePicker } from "antd";

export const Route = createFileRoute("/")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div>
      Hello
      <Space>
        <DatePicker />
        <Button type="primary">Primary Button</Button>
      </Space>
    </div>
  );
}
