import { useEffect, useCallback, useState } from "react";
import { useAccount, useWalletClient } from "wagmi";
import { formatEther, parseEther } from "viem";
import Card from "../../components/card";
import { useStakeContract } from "../../hooks/useContract";
import { Pid } from "../../constants";
import { waitForTransactionReceipt } from "viem/actions";
import { toast } from "react-toastify";

const config = [
  {
    label: "Staked Amount",
    field: "staked",
  },
  {
    label: "Available to withdraw",
    field: "availableWithdraw",
  },
  {
    label: "Pending Withdraw",
    field: "pendingWithdraw",
  },
];
export default function Withdraw() {
  const [unStakedAmount, setUnstakeAmount] = useState("");
  const { address, isConnected } = useAccount();
  const { data } = useWalletClient();
  const [stakes, setStakes] = useState({
    staked: 0,
    availableWithdraw: 0,
    pendingWithdraw: 0,
  });

  const stakeContract = useStakeContract();

  const getUserData = useCallback(async () => {
    if (!address || !stakeContract) return;
    const stakedAmount = await stakeContract?.read.stakingBalance([
      Pid,
      address,
    ]);
    let [requestAmount, pendingWithdrawAmount] =
      await stakeContract?.read.withdrawAmount([Pid, address]);
    requestAmount = formatEther(requestAmount);
    pendingWithdrawAmount = formatEther(pendingWithdrawAmount);
    setStakes({
      staked: formatEther(stakedAmount),
      availableWithdraw: pendingWithdrawAmount,
      pendingWithdraw: requestAmount - pendingWithdrawAmount,
    });
  }, [stakeContract, address]);

  const handleUnStake = useCallback(async () => {
    if (!unStakedAmount) {
      toast.error("Please enter the amount to unstak.");
      return;
    }
    try {
      const tx = await stakeContract?.write.unstake([
        Pid,
        parseEther(unStakedAmount),
      ]);
      await waitForTransactionReceipt(data, { hash: tx });
      toast.success("操作成功");
      setUnstakeAmount("");
      getUserData();
    } catch (error) {
      console.error("UnStake error: ", error);
    }
  }, [stakeContract, address, unStakedAmount, getUserData]);

  const handleWithdraw = useCallback(async () => {
    if (!Number(stakes.availableWithdraw)) {
      toast.error("Zero ready amount.");
      return;
    }
    try {
      const tx = await stakeContract?.write.withdraw([Pid]);
      await waitForTransactionReceipt(data, { hash: tx });
      toast.success("操作成功");
      getUserData();
    } catch (error) {
      console.error("Withdraw error: ", error);
    }
  }, [stakes, stakeContract, getUserData]);

  useEffect(() => {
    getUserData();
  }, [getUserData]);

  return (
    <Card>
      <div className="px-3 py-4">
        <div className="flex">
          {config.map((item) => (
            <div key={item.field} className="flex-1 text-center">
              <div className="text-md">{item.label}</div>
              <div className="font-bold text-xl">{stakes[item.field]} ETH</div>
            </div>
          ))}
        </div>
        <div className="mt-6 flex flex-col items-center">
          <div className="mb-3 font-bold">UnStake</div>
          <input
            value={unStakedAmount}
            type="text"
            className="p-2 border border-gray-300 rounded-md w-1/2"
            placeholder="please enter the amount to unstake"
            onChange={(e) => setUnstakeAmount(e.target.value)}
          />
          {isConnected ? (
            <button
              onClick={handleUnStake}
              className="w-1/2 mt-2 p-2 bg-blue-500 text-white rounded-md block cursor-pointer"
            >
              unStake
            </button>
          ) : (
            <div className="text-center text-xl mt-3">
              Please connect the wallet
            </div>
          )}
          <div className="mt-5 font-bold">Withdraw</div>
          <div>Ready Amount: {stakes.availableWithdraw}</div>
          <div className="text-xs text-gray-500 my-1">
            After unstaking, you need to wait 20 minutes to withdraw.
          </div>
          {isConnected ? (
            <button
              onClick={handleWithdraw}
              className="w-1/2 mt-2 p-2 bg-blue-500 text-white rounded-md block cursor-pointer"
            >
              withdraw
            </button>
          ) : (
            <div className="text-center text-xl">Please connect the wallet</div>
          )}
        </div>
      </div>
    </Card>
  );
}
