;; Skills NFT Contract

(define-non-fungible-token skills-nft uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata
  { token-id: uint }
  {
    skill-name: (string-utf8 100),
    owner: principal,
    description: (string-utf8 500),
    achievement-date: uint,
    issuer: principal
  }
)

(define-public (mint-skill-nft (skill-name (string-utf8 100)) (description (string-utf8 500)) (recipient principal))
  (let
    ((new-token-id (+ (var-get last-token-id) u1))
     (issuer tx-sender))
    (try! (nft-mint? skills-nft new-token-id recipient))
    (map-set token-metadata
      { token-id: new-token-id }
      {
        skill-name: skill-name,
        owner: recipient,
        description: description,
        achievement-date: block-height,
        issuer: issuer
      }
    )
    (var-set last-token-id new-token-id)
    (ok new-token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (nft-transfer? skills-nft token-id sender recipient)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata { token-id: token-id })
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? skills-nft token-id))
)

