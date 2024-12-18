;; Dataset NFT Contract

(define-non-fungible-token dataset-nft uint)

(define-map dataset-metadata
  { dataset-id: uint }
  {
    owner: principal,
    name: (string-utf8 100),
    description: (string-utf8 500),
    ipfs-hash: (string-ascii 46),
    price: uint,
    is-private: bool
  }
)

(define-data-var last-dataset-id uint u0)

(define-public (mint-dataset (name (string-utf8 100)) (description (string-utf8 500)) (ipfs-hash (string-ascii 46)) (price uint) (is-private bool))
  (let
    (
      (dataset-id (+ (var-get last-dataset-id) u1))
    )
    (try! (nft-mint? dataset-nft dataset-id tx-sender))
    (map-set dataset-metadata
      { dataset-id: dataset-id }
      {
        owner: tx-sender,
        name: name,
        description: description,
        ipfs-hash: ipfs-hash,
        price: price,
        is-private: is-private
      }
    )
    (var-set last-dataset-id dataset-id)
    (ok dataset-id)
  )
)

(define-read-only (get-dataset-metadata (dataset-id uint))
  (ok (unwrap! (map-get? dataset-metadata { dataset-id: dataset-id }) (err u404)))
)

(define-public (transfer-dataset (dataset-id uint) (recipient principal))
  (begin
    (try! (nft-transfer? dataset-nft dataset-id tx-sender recipient))
    (let
      (
        (metadata (unwrap! (map-get? dataset-metadata { dataset-id: dataset-id }) (err u404)))
      )
      (map-set dataset-metadata
        { dataset-id: dataset-id }
        (merge metadata { owner: recipient })
      )
      (ok true)
    )
  )
)

