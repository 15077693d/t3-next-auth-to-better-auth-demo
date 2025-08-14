"use client";

import { useRouter } from "next/navigation";
import { authClient } from "~/lib/auth-client";
import type { auth } from "~/server/auth";

export default function SignInSignOutButton({
  session,
}: {
  session: Awaited<ReturnType<typeof auth.api.getSession>>;
}) {
  const router = useRouter();
  const handleClick = () => {
    if (session) {
      void authClient.signOut({
        fetchOptions: {
          onSuccess: () => {
            router.push("/"); // redirect to login page
          },
        },
      });
    } else {
      void authClient.signIn.social({
        /**
         * The social provider ID
         * @example "github", "google", "apple"
         */
        provider: "discord",
        /**
         * A URL to redirect after the user authenticates with the provider
         * @default "/"
         */
        /**
         * A URL to redirect if an error occurs during the sign in process
         */
        errorCallbackURL: "/error",
      });
    }
  };
  return (
    <button
      onClick={handleClick}
      className="rounded-full bg-white/10 px-10 py-3 font-semibold no-underline transition hover:bg-white/20"
    >
      {session ? "Sign out" : "Sign in"}
    </button>
  );
}
