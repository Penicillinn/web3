import { ConnectButton } from "@rainbow-me/rainbowkit";
import Link from "next/link";
import { usePathname } from "next/navigation";

const Links = [
  {
    name: "Stake",
    path: "/",
  },
  {
    name: "Withdrawal",
    path: "/withdraw",
  },
];

export default function Header() {
  const pathname = usePathname();
  return (
    <div className="flex justify-between items-center py-2 px-4 border-b-1 border-[#eaeaea]">
      <div className="text-2xl">RCCStake</div>
      <div className="flex items-center gap-7">
        {Links.map((item) => (
          <Link
            key={item.path}
            href={item.path}
            className={item.path === pathname ? "font-bold" : ""}
          >
            {item.name}
          </Link>
        ))}
        <ConnectButton />
      </div>
    </div>
  );
}
