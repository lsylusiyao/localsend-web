export const DEFAULT_SIGNALING_URL = "wss://public.localsend.org/v1/ws";

type RuntimeConfig = {
  signalingUrl?: string;
};

declare global {
  interface Window {
    __LOCALSEND_RUNTIME_CONFIG__?: RuntimeConfig;
  }
}

export const getSignalingUrl = () => {
  if (import.meta.client) {
    return (
      window.__LOCALSEND_RUNTIME_CONFIG__?.signalingUrl ??
      DEFAULT_SIGNALING_URL
    );
  }

  return DEFAULT_SIGNALING_URL;
};
